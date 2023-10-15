import { useQuasar } from 'quasar'

export default function useNotify () {
  const $q = useQuasar()

  const notifySuccess = (message = '', caption = '', timeout = 5000) => {
    $q.notify({
      position: 'top-right',
      timeout: timeout,
      type: 'positive',
      message: message || 'All right !',
      caption: caption
    })
  }

  const notifyError = (message = '', caption = '', timeout = 5000) => {
    $q.notify({
      position: 'top-right',
      timeout: timeout,
      type: 'negative',
      message: message || 'Failed !',
      caption: caption
    })
  }

  const notifyWarning = (message = '', caption = '', timeout = 5000) => {
    $q.notify({
      position: 'top-right',
      timeout: timeout,
      type: 'warning',
      message: message || 'Warning !',
      caption: caption
    })
  }

  return {
    notifySuccess,
    notifyWarning,
    notifyError
  }
}
