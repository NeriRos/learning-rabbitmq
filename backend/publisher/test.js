import amqp from 'amqplib'

const host = `learning-rabbitmq.dev:5672`
const url = `amqp://${host}/api/rabbit`
console.log("Testing rabbitmq with this", url)

const rabbitMQTest = {
    listen: () => {
        amqp.connect(url, (error0, connection) => {
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
        })
    }
}

export {rabbitMQTest}
