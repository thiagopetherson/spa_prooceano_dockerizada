<template>
  <q-page class="flex" padding>
    <div class="row justify-center items-center full-width">
      <q-form class="col-xs-10 col-sm-10 col-md-4" @submit.prevent="handleImport">
        <p class="col-12 text-h5 text-center q-pb-lg">Importação de Planilha</p>
        <div class="q-gutter-y-md">
          <q-file
            bottom-slots
            v-model="form.archive"
            label="Selecione o Arquivo"
            counter
            accept=".xls, .xlsx"
            max-file-size="5120000"
          >
            <template v-slot:prepend>
              <q-icon name="cloud_upload" @click.stop.prevent />
            </template>
            <template v-slot:append>
              <q-icon name="close" @click.stop.prevent="form.archive = null" class="cursor-pointer" />
            </template>

            <template v-slot:hint>
              Tamanho do Arquivo
            </template>
          </q-file>
          <q-btn type="submit" label="Importar" color="primary" class="full-width q-pa-sm" />
        </div>
      </q-form>
    </div>
  </q-page>
</template>

<script>
import { defineComponent, ref } from 'vue'
import { useQuasar, QSpinnerFacebook } from 'quasar'
import useImportApi from 'src/composables/requests/UseImportApi'

export default defineComponent({
  name: 'ImportFormView',
  setup () {
    // Imports
    const { importSpreadsheet } = useImportApi()
    const $q = useQuasar()

    const form = ref({
      archive: null
    })

    // Methods
    const handleImport = async () => {
      showLoading()
      await importSpreadsheet('spreadsheet-import', form.value)
      form.value.archive = null
      hideLoading()
    }

    const showLoading = () => {
      $q.loading.show({
        spinner: QSpinnerFacebook,
        message: 'Seus dados estão sendo importados...',
        spinnerColor: 'white',
        spinnerSize: 140,
        backgroundColor: 'primary',
        messageColor: 'white'
      })
    }

    const hideLoading = () => {
      $q.loading.hide()
    }

    return {
      form,
      handleImport
    }
  }
})
</script>
