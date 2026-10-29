const CACHE_NAME = "ychat-v6";

const urlsToCache = [
  "/",
  "/manifest.json"
  // প্রয়োজন হলে এখানে তোমার real page add করো (যেমন /index.jsp)
];

// Install → cache basic files
self.addEventListener("install", event => {
  console.log("Service Worker installing...");
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
  self.skipWaiting();
});

// Activate → clean old cache
self.addEventListener("activate", event => {
  console.log("Service Worker activated");

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

// Fetch → network first, fallback to cache
self.addEventListener("fetch", event => {
  event.respondWith(
    fetch(event.request)
      .then(response => {
        // cache new request
        const responseClone = response.clone();
        caches.open(CACHE_NAME)
          .then(cache => cache.put(event.request, responseClone));

        return response;
      })
      .catch(() => {
        // offline fallback
        return caches.match(event.request);
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