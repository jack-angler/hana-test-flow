function CommonDialog({
  isOpen,
  title = '알림',
  message,
  confirmText = '확인',
  cancelText,
  onConfirm,
  onCancel,
}) {
  if (!isOpen) {
    return null
  }

  return (
    <div className="modal-backdrop" role="presentation">
      <div className="common-dialog" role="dialog" aria-modal="true">
        <h2>{title}</h2>
        <p>{message}</p>
        <div className="common-dialog-actions">
          {onCancel && (
            <button type="button" className="secondary-button" onClick={onCancel}>
              {cancelText ?? '취소'}
            </button>
          )}
          <button type="button" className="primary-button" onClick={onConfirm}>
            {confirmText}
          </button>
        </div>
      </div>
    </div>
  )
}

export default CommonDialog
