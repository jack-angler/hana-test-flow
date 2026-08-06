const API_BASE_URL = import.meta.env.VITE_API_BASE_URL

export function apiUrl(path) {
  const normalizedPath = path.startsWith('/') ? path : `/${path}`

  return `${API_BASE_URL}${normalizedPath}`
}

export async function apiRequest(path, options = {}) {
  const hasBody = options.body !== undefined
  const isFormData =
    typeof FormData !== 'undefined' && options.body instanceof FormData
  const defaultHeaders =
    hasBody && !isFormData ? { 'Content-Type': 'application/json' } : {}

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
    const message = data?.message ?? 'API request failed.'
    const detail = data?.error ? `\n${data.error}` : ''

    throw new Error(`${message}${detail}`)
  }

  return data
}

export { API_BASE_URL }
