const API_BASE_URL = import.meta.env.VITE_API_BASE_URL

export function apiUrl(path) {
  const normalizedPath = path.startsWith('/') ? path : `/${path}`

  return `${API_BASE_URL}${normalizedPath}`
}

export async function apiRequest(path, options = {}) {
  const hasBody = options.body !== undefined
  const defaultHeaders = hasBody ? { 'Content-Type': 'application/json' } : {}

  const response = await fetch(apiUrl(path), {
    headers: {
      ...defaultHeaders,
      ...(options.headers ?? {}),
    },
    credentials: 'include',
    ...options,
  })

  const data = await response.json().catch(() => null)

  if (!response.ok) {
    throw new Error(data?.message ?? 'API request failed.')
  }

  return data
}

export { API_BASE_URL }
