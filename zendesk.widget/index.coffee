# Specify your Zendesk subdomain.
# For example for https://obscura.zendesk.com/ it will be "obscura"

subdomain = 'obscura'

# API token
# you can create one here https://obscura.zendesk.com/agent/admin/api
token = '94a08da1fecbb6e8b46990538c7b50b2'

#User email
email = 'email@gmail.com'

# Position and style
width = 'auto'
top = 'auto'
bottom = '80px'
left = '1%'
right = 'auto'

#Show names of lists
showListsNames: true, # true / false

#Show lists by names
#Example: ['New', 'Open', 'Pending']
showLists: [] #show all by default

#Show only a certain number of tasks from a specific list
iNumbers:
  'new': 10
  'open': 10
  'pending': 10

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000 * 60 #1 minute



###
YOU DO NOT NEED EDIT ANYTHING BELOW
but off-course you can if you want
###

subdomain: subdomain
style: """
	bottom: #{bottom}
	top: #{top}
	left: #{left}
	right: #{right}
	width: #{width}
	color: #fff
	background: rgba(#525252,0.9)
	font-family: Myriad Set Pro, Helvetica Neue
	font-size: 10pt
	border-radius: 3px

	.lists,.tasks
		margin: 0
		padding: 0

	.list,.task
			list-style: none

	.list:first-child .list-info
		border-top-left-radius: 3px
		border-top-right-radius: 3px

	.list-info
		background: rgba(0,0,0,0.2)
		position: relative
		font-weight: bold

	.list-name
		padding: 5px 10px
		margin: 0 40px 0 0
		overflow: hidden
		text-overflow: ellipsis
		position: relative
		white-space: nowrap
		opacity: 0.85

	.list-info.Open,.list-info.New
		background: #E82A2A

	.list-info.Pending
		background: #59BBE0

	.tasks-length
		position: absolute
		top: 0px
		right: 5px
		opacity: 0.85
		padding: 5px 5px

	.task
		margin: 0 10px
		padding: 5px 0 5px 20px
		white-space: nowrap
		overflow: hidden
		text-overflow: ellipsis
		position: relative
		opacity: 0.85
		a
			color: #fff
			text-decoration: none
			&:hover
				text-decoration: underline

	.task::after
		content: ""
		position: absolute
		width: 10px
		height: 10px
		background: rgba(0,0,0,0.3)
		-webkit-border-radius: 20px
		left: 0
		top: 8px

	.error
		padding: 5px
		background: rgba(0,0,0,0.3)
"""

render: (_) -> """
	<div class='to-do-wrap'>Loading...</div>
"""

command: "curl -u #{email}/token:#{token} https://#{subdomain}.zendesk.com/api/v2/search.json -G --data-urlencode 'query=type:ticket status<solved' --data-urlencode 'sort_by=status' --data-urlencode 'sort_order=asc' -s"

fetchTasks: (output) ->
  json = JSON.parse(output)
  json.results


buildTree: (tasks) ->
  tree = {}
  lists = [
    {
      title: 'New',
      status: 'new'
    },
    {
      title: 'Open',
      status: 'open'
    }, {
      title: 'Pending',
      status: 'pending'
    }]

  iNumbers = @iNumbers

  lists.forEach (l) =>
    tasksArr = []
    n = 0
    tasks.forEach (t) ->
      if (!iNumbers[l.status] || n < iNumbers[l.status]) && l.status == t.status || l.id == 'starred' && t.starred
        tasksArr.push
          title: t.subject
          id: t.id
        n++;
    tree[l.title] = tasksArr

  @tree = tree

_sort: (arr) ->
  arr.sort (a, b) ->
    if a.position < b.position
      return -1
    else
      return 1
  return arr

_render: () ->
  str = '<ul class="lists">'
  listNameTpl = ''
  tree = if @showLists.length then @showLists else Object.keys(@tree)
  tree.forEach (listName) =>
    tasks = @tree[listName]
    n = tasks.length
    if n
      if @showListsNames
        listNameTpl = '<div class="list-info ' + listName + '">' +
            '<div class="list-name">' + listName + '</div>' +
            '<div class="tasks-length">' + n + '</div>' +
            '</div>'

      tasksList = ''
      tasks.forEach (task) =>
        tasksList+= '<li class="task"><a href="https://'+@subdomain+'.zendesk.com/agent/tickets/'+task.id+'">'+task.title+'</a></li>'

      str += '<li class="list">' +
          listNameTpl +
          '<ul class="tasks">' +
          tasksList+
          '</ul>' +
          '</li>'
  str += '</ul>'

  @content.html str

update: (output, domEl) ->



  if !@content
    @content = $(domEl).find('.to-do-wrap')

  @tasks = @fetchTasks output
  @tree = @buildTree @tasks
  @_render ''
  .bind(this)