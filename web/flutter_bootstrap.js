{{flutter_js}}
{{flutter_build_config}}

function registerOfflineWorker() {
  if (!('serviceWorker' in navigator)) {
    return;
  }

  const workerUrl = new URL('buscaminas_service_worker.js', document.baseURI);
  navigator.serviceWorker.register(workerUrl).catch((error) => {
    console.warn('No se pudo registrar el service worker offline:', error);
  });
}

if (document.readyState === 'complete') {
  registerOfflineWorker();
} else {
  window.addEventListener('load', registerOfflineWorker, { once: true });
}

_flutter.loader.load();
