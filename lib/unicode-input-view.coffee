{$, TextEditorView, View}  = require 'atom-space-pen-views'

module.exports =
class UnicodeInputView extends View
  @activate: -> new UnicodeInputView

  @content: ->
    @div =>
      @h1 'Unicode Input'
      @subview 'hexValueInput', new TextEditorView(mini: true, placeHolderText: 'Unicode Hex Value')

  initialize: ->
    @panel = atom.workspace.addModalPanel(item: this, visible: false)

    atom.commands.add 'atom-text-editor', 'unicode-input:toggle', => @toggle()

    atom.commands.add @hexValueInput.element, 'core:confirm', => @confirm()
    atom.commands.add @hexValueInput.element, 'core:cancel', => @cancel()

  toggle: ->
    if @panel.isVisible()
      @cancel()
    else
      @show()

  cancel: ->
    hexValueInputFocused = @hexValueInput.hasFocus()
    @hexValueInput.setText('')
    @panel.hide()
    @restoreFocus()

  confirm: ->
    hexValue = @hexValueInput.getText()
    editor = atom.workspace.getActiveEditor()

    @cancel()

    return unless editor and hexValue.length
    editor.insertText(String.fromCharCode(parseInt(hexValue, 16)))

  storeFocusedElement: ->
    @previouslyFocusedElement = $(document.activeElement)

  restoreFocus: ->
    @previouslyFocusedElement?.focus()

  show: ->
    @storeFocusedElement()
    @panel.show()
    @hexValueInput.focus()
