import { api } from 'boot/axios'
import useNotify from 'src/composables/notifications/UseNotify' // Importing composable notification
import { LocalStorage } from 'quasar'

export default function useImportApi () {
  const { notifyWarning, notifyError, notifySuccess } = useNotify()

  let token = ''

  // Methods
  const importSpreadsheet = async (endpoint, data) => {
    token = LocalStorage.getItem('token')

    if (data.archive === null) {
      notifyWarning('Falha na Importação do Arquivo', 'Para prosseguir, insira um arquivo válido!')
      return
    }

    const formData = new FormData()
    formData.append('project_id', data.project_id)
    formData.append('archive', data.archive)

    await api.post(endpoint, formData, {
      headers: { Authorization: `Bearer ${token}` }
    }).then(response => {
      notifySuccess(response.data.message)
    }).catch(error => {
      errorMessage(error)
    })
  }

  const errorMessage = (error) => {
    if (error.response.status === 500) {
      notifyError('Falha na Importação do Arquivo', 'Por favor, verifique e tente novamente!', 8000)
      console.log(error.response.data.message)
    }

    if (error.response.data.errors) {
      Object.keys(error.response.data.errors).forEach(key => {
        notifyError(error.response.data.errors[key][0])
      })
    }

    if (error.response.data.error) notifyError(error.response.data.error)
  }

  return {
    importSpreadsheet
  }
}
