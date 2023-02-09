import amqp from 'amqplib'

const rabbitMQTest = {
    listen: () => {
        amqp.connect("amqp://localhost", (error0, connection) => {
            if (error0)
                return error0

            connection.createChannel((error1, channel) => {
                if (error1)
                    return error1

                let queue = 'testqueue'

                channel.assertQueue(queue, {
                    durable: false
                })

                console.log(" [*] Waiting for messages in %s. To exit press CTRL+C", queue);
                channel.consume(queue, function (msg) {
                    console.log(" [x] Received %s", msg.content.toString());
                }, {
                    noAck: true
                });
            })
        })
    },
    send: () => {
        amqp.connect("amqp://localhost", (error0, connection) => {
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
        })
    }
}

export {rabbitMQTest}
