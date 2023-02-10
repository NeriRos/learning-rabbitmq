import amqp from 'amqplib'

const host = 'rabbitmq-instance' //`learning-rabbitmq.dev`
const auth = 'default_user_Sy1olVywlDmRnlHArLI:8_rpRIb9WBY3ez7knAX1gZ_EaMuViu6m' //`learning-rabbitmq.dev`
// const auth = 'guest:guest' //`learning-rabbitmq.dev`
const url = `amqp://${auth}@${host}`
// const url = `amqp://${host}`

console.log("Testing rabbitmq with this url %s", url)

const rabbitMQTest = {
    test: async () => {
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
}

export {rabbitMQTest}
