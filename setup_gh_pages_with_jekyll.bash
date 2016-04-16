function install_jekyll_if_not_installed {
    cd $GOPATH
    if [ "$(gem list jekyll -i)" == "true" ]
    then
        echo "jekyll is installed."
    else
        echo "jekyll needs to be installed."
        gem install jekyll
    fi
}

function clone_repository_into_c9_project_home {
    cd $GOPATH
    git clone $url_to_clone
    cd $repo_name_from_url
    git checkout --orphan gh-pages
}

function create_jekyll_site_and_move_to_copy_to_repo {
    cd $GOPATH
    jekyll new temp_site
    cd temp_site
    rewrite_yml_file
    create_readme_file
    shopt -s dotglob
    mv * $GOPATH/$repo_name_from_url
    cd $GOPATH
    rm -d temp_site
}

function rewrite_yml_file {
cat >  _config.yml << EOL
name: $repo_name_from_url gh-pages site!
markdown: redcarpet
pygments: true
baseurl: /$repo_name_from_url
EOL
}

function create_readme_file {
cat >  README.md << EOL
This is a script created gh-pages site for the $repo_name_from_url repository!   
EOL
}

function add_commit_and_push_to_github {
    cd $GOPATH
    cd $repo_name_from_url
    git add .
    git commit -m 'Script commit from setup_gh_pages_with_jekyll.bash script.'
    git push --all
}

function git_config_global_cache {
    git config --global credential.helper 'cache --timeout=1800'
}

function set_vars {
    url_to_clone="$1"
    repo_name_from_url="$(echo "$1" | sed 's%^.*/\([^/]*\)\.git$%\1%g')"
}

function test_vars {
    echo "url_to_clone = $url_to_clone"
    echo "repo_name_from_url = $repo_name_from_url"
}

function remove_posts_from_posts_directory {
    cd $repo_name_from_url
    rm -rf -- "_posts"
    mkdir "_posts"
    cd $GOPATH
}

function create_basic_introduction_post {
    cd $GOPATH
    cd $repo_name_from_url/_posts
    date=`date +%Y-%m-%d`
    time=`date +%H:%M:%S`
    zone=`date +%z`
    new_post_file_name="$date-first_post.markdown"
    
cat > $new_post_file_name << EOF
---
layout: post
title:  "Welcome to the $repo_name_from_url repository!"
date:   $date $time $zone
categories: introduction automation
---
EOF

    cd $GOPATH
}

function do_the_script_please {
    if [ -z "$1" ]
    then
        echo "NEED REPOSITORY URL!"
    else
        echo "RUNNNG"
        set_vars "$1"
        git_config_global_cache
        install_jekyll_if_not_installed
        clone_repository_into_c9_project_home
        create_jekyll_site_and_move_to_copy_to_repo
        remove_posts_from_posts_directory
        create_basic_introduction_post
        add_commit_and_push_to_github
    fi
}

do_the_script_please "$1"
