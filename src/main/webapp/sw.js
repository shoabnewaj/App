const CACHE_NAME = "ychat-v7";

const urlsToCache = [
  "/manifest.json"
];

// Install → cache basic files
self.addEventListener("install", event => {
  self.skipWaiting();
});

// Activate → clean old cache
self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.map(key => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
        })
      );
    })
  );
  self.clients.claim();
});

// Fetch → network first, NEVER cache POST/PUT/DELETE requests (Safari throws TypeError on cache.put for POST)
self.addEventListener("fetch", event => {
  if (event.request.method !== 'GET') {
    return; // Pass through directly to network
  }

  const url = new URL(event.request.url);
  // Do not cache API / Servlet endpoints or dynamic JSP pages
  if (url.pathname.includes('Servlet') || url.pathname.endsWith('.jsp') || url.search.includes('ajax=true')) {
    event.respondWith(
      fetch(event.request).catch(() => caches.match(event.request))
    );
    return;
  }

  // Static assets (css, js, images)
  event.respondWith(
    fetch(event.request)
      .then(response => {
        if (response && response.status === 200 && response.type === 'basic') {
          const responseClone = response.clone();
          caches.open(CACHE_NAME).then(cache => {
            try { cache.put(event.request, responseClone); } catch (e) {}
          });
        }
        return response;
      })
      .catch(() => caches.match(event.request))
  );
});

// Push Notifications
self.addEventListener("push", event => {
  let data = { title: "yChat", body: "You have a new message or update!", icon: "favicon.ico", url: "/" };
  if (event.data) {
    try {
      data = Object.assign(data, event.data.json());
    } catch (e) {
      data.body = event.data.text();
    }
  }
  const options = {
    body: data.body,
    icon: data.icon || "favicon.ico",
    badge: "favicon.ico",
    vibrate: [100, 50, 100],
    data: {
      url: data.url || "/"
    }
  };
  event.waitUntil(
    self.registration.showNotification(data.title, options)
  );
});

// Notification Click -> Focus or open window
self.addEventListener("notificationclick", event => {
  event.notification.close();
  const targetUrl = (event.notification.data && event.notification.data.url) ? event.notification.data.url : "/";
  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then(clientList => {
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i];
        if (client.url && "focus" in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(targetUrl);
      }
    })
  );
});

// Push Notifications
self.addEventListener("push", event => {
  let data = { title: "yChat", body: "You have a new message or update!", icon: "favicon.ico", url: "/" };
  if (event.data) {
    try {
      data = Object.assign(data, event.data.json());
    } catch (e) {
      data.body = event.data.text();
    }
  }
  const options = {
    body: data.body,
    icon: data.icon || "favicon.ico",
    badge: "favicon.ico",
    vibrate: [100, 50, 100],
    data: {
      url: data.url || "/"
    }
  };
  event.waitUntil(
    self.registration.showNotification(data.title, options)
  );
});

// Notification Click -> Focus or open window
self.addEventListener("notificationclick", event => {
  event.notification.close();
  const targetUrl = (event.notification.data && event.notification.data.url) ? event.notification.data.url : "/";
  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then(clientList => {
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i];
        if (client.url && "focus" in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(targetUrl);
      }
    })
  );
});