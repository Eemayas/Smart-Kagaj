require("dotenv").config();
const express = require("express");
// const { Redis } = require("@upstash/redis");
const { Redis } = require("ioredis") 

/**
 * @returns {string} The Upstash path
 */
const getUpstashPath = () => { 
    const upstash_path = process.env.UPSTASH_PATH;
    
    if (upstash_path === undefined) {
        throw new Error("Please set the UPSTASH_PATH environment variable");
    }

    return upstash_path;
}

const app = express();
const port = process.env.PORT || 8000;

app.use(express.json());

app.post("/cache", async (req, res) => {
    const { 
        contractHash, 
        date, 
        name, 
        content, 
        terms
    } = req.body;
    console.log(contractHash)

    if (contractHash === undefined || date === undefined || name === undefined || content === undefined || terms === undefined) {
        res.status(400).send("Bad Request");
        return;
    }

    try {
        const client = new Redis(getUpstashPath());
        // const result = await client.set(contractHash, JSON.stringify({
        //     contractHash,
        //     date,
        //     name,
        //     content,
        //     terms
        // }), { ex: 60 * 60 * 24 * 7 });
        const result = await client.set(contractHash, JSON.stringify({
            contractHash,
            date,
            name,
            content,
            terms
        }));
        await client.expire(contractHash, 60 * 60 * 24 * 7);
        console.log("Got result")

        if (result === "OK") {
            res.status(200).send("OK");
        } else {
            res.status(500).send("Error");
        }
        client.disconnect();
    } catch (error) {
        console.log(error)
        res.status(500).send("Server Error");
        client.disconnect();
    }
})
.get("/cache/:contractHash", async (req, res) => {
    const { contractHash } = req.params;
    console.log(contractHash)
    if (contractHash === undefined) {
        res.status(400).send("Bad Request");
        return;
    }
    try {
        const client = new Redis(getUpstashPath());

        const result = await client.get(contractHash);

        if (result === null) {
            res.status(404).send("Not Found");
        } else {
            res.status(200).send(result);
        }
        client.disconnect();
    } catch (error) {
        console.log(error)
        res.status(500).send("Server Error");
        client.disconnect();
    }
})
.delete("/cache/:contractHash", async (req, res) => {
    const { contractHash } = req.params;
    if (contractHash === undefined) {
        res.status(400).send("Bad Request");
        return;
    }
    try {
        const client = new Redis(getUpstashPath());

        const result = await client.del(contractHash);

        if (result === 1) {
            res.status(200).send("OK");
        } else {
            res.status(404).send("Not Found");
        }
        client.disconnect();
    } catch (error) {
        console.log(error)
        res.status(500).send("Server Error");
        client.disconnect();
    }
})
.put("/cache", async(req, res) => {
    const { 
        contractHash, 
        date, 
        name, 
        content, 
        terms
    } = req.body;
    console.log(contractHash)

    if (contractHash === undefined || date === undefined || name === undefined || content === undefined || terms === undefined) {
        res.status(400).send("Bad Request");
        return;
    }

    try {
        const client = new Redis(getUpstashPath());

        const result = await client.getset(contractHash, JSON.stringify({
            contractHash,
            date,
            name,
            content,
            terms
        }));

        if (result === null) {
            res.status(404).send("Not Found");
        } else {
            res.status(200).send(result);
        }
        client.disconnect();
    } catch(error) {
        console.log(error)
        res.status(500).send("Server Error");
        client.disconnect();
    }
});

app.listen(port, () => {
    console.log(`App listening on port ${port}`);
});