import amqp from 'amqplib'


const rabbitMQTest = async () => {
    const host = process.env.RABBITMQ_HOST
    const username = process.env.RABBITMQ_USERNAME;
    const password = process.env.RABBITMQ_PASSWORD;
    const url = `amqp://${username}:${password}@${host}`

    console.log("Testing rabbitmq with this url %s", url)

    const queue = 'tasks';
    const conn = await amqp.connect(url);

    const ch1 = await conn.createChannel();
    await ch1.assertQueue(queue);

    // Listener
    ch1.consume(queue, (msg) => {
        if (msg !== null) {
            console.log('Received:', msg.content.toString());
            ch1.ack(msg);
        } else {
            console.log('Consumer cancelled by server');
        }
    });

    // Sender
    const ch2 = await conn.createChannel();

    setInterval(() => {
        ch2.sendToQueue(queue, Buffer.from('something to do'));
    }, 1000);

    amqp.connect(url, (error0, connection) => {
        if (error0)
            return error0
        console.log("Connected!")

        connection.createChannel((error1, channel) => {
            if (error1)
                return error1

            let queue = 'testqueue'

            channel.assertQueue(queue, {
                durable: false
            })

            channel.sendToQueue(queue, Buffer.from('TESTTTT'))

            console.log("SENT!")
        })

        process.on('exit', () => connection.disconnect())
    })

    process.on('exit', () => conn.disconnect())
}

export {rabbitMQTest}
