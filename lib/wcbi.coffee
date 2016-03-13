WcbiView = require './wcbi-view'
{CompositeDisposable} = require 'atom'

module.exports = Wcbi =
  wcbiView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @wcbiView = new WcbiView(state.wcbiViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @wcbiView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'wcbi:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @wcbiView.destroy()

  serialize: ->
    wcbiViewState: @wcbiView.serialize()

  toggle: ->
    console.log 'Wcbi was toggled!'

    if @modalPanel.isVisible()
        @modalPanel.hide()
    else
        editor = atom.workspace.getActiveTextEditor()
        words = editor.getText().split(/\s+/).length
        @wcbiView.setCount(words)
        @modalPanel.show()
