MESSAGE = "Update readme"

system('git config --global user.email "githubactions@example.com"')
system('git config --global user.name "GitHub Actions"')
system("git add .")

latest_commit_message = `git log -1 --pretty=%B`

puts "Last commit: '#{latest_commit_message}'"

if latest_commit_message.include? MESSAGE
  puts "Updating last update commit"
  system("git commit --amend --no-edit")
  system("git push -f")
else
  puts "Creating new update commit..."
  system("git commit -m '#{MESSAGE}'")
  system("git push")
end
