function CommonDialog({
  isOpen,
  title = '알림',
  message,
  confirmText = '확인',
  onConfirm,
}) {
  if (!isOpen) {
    return null
  }

  return (
    <div className="modal-backdrop" role="presentation">
      <div className="common-dialog" role="dialog" aria-modal="true">
        <h2>{title}</h2>
        <p>{message}</p>
        <button type="button" className="primary-button" onClick={onConfirm}>
          {confirmText}
        </button>
      </div>
    </div>
  )
}

export default CommonDialog
