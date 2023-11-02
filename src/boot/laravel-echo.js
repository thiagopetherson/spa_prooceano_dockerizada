import { boot } from "quasar/wrappers"
import Echo from "laravel-echo"
import Pusher from "pusher-js"

let echo
let token = localStorage.getItem('token')

export default boot(async () => {
  window.Pusher = Pusher

  echo = new Echo({
    broadcaster: 'pusher',
    key: process.env.VUE_APP_PUSHER_APP_KEY, // myappkey
    cluster: process.env.VUE_PUSHER_APP_CLUSTER, //'mt1',
    wsHost: window.location.hostname, // '127.0.0.1',
    // wsPath: '/backend', // Não existia
    authEndpoint: 'http://' + window.location.hostname + '/broadcasting/auth', // http://127.0.0.1:8000/broadcasting/auth
    encrypted: true,
    forceTLS: false,
    wsPort: 9000, // window.location.port, // 6001
    wssPort: 9000, // window.location.port, // 6001
    disableStats: true,
    enabledTransports: ['ws', 'wss'],
    auth: {
      headers: {
        authorization: 'Bearer ' + token
      }
    }
  })
})

export { echo }
