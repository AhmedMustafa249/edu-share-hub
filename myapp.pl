#!/usr/bin/env perl
use Mojolicious::Lite;
use DBI;

# Database configuration
my $dsn = "DBI:MariaDB:database=testdb;host=mariadb;port=3306";
my $username = "root";
my $password = "rootpassword";

# DB connection
helper db => sub {
    DBI->connect($dsn, $username, $password, { RaiseError => 1, AutoCommit => 1 });
};

# Route: Display form and messages
get '/' => sub {
    my $c = shift;

    # Fetch all messages from the database
    my $sth = $c->db->prepare("SELECT name, message FROM messages");
    $sth->execute;

    my @messages;
    while (my $row = $sth->fetchrow_hashref) {
        push @messages, $row;
    }

    $c->stash(messages => \@messages);
    $c->render(template => 'login');
};

# Route: Add message
post '/add' => sub {
    my $c = shift;

    my $name    = $c->param('name');
    my $message = $c->param('message');

    # Insert into database
    my $sth = $c->db->prepare("INSERT INTO messages (name, message) VALUES (?, ?)");
    $sth->execute($name, $message);

    $c->render(json => { status => 'success' });
};

get '/dashboard' => sub {
    my $c = shift;

    # Fetch resource details from the 'resources' table
    my $sth = $c->db->prepare("SELECT id, name, description, category, shared_with, session, resource_link FROM resources");
    $sth->execute;

    my @resources;
    while (my $row = $sth->fetchrow_hashref) {
        warn "Fetched Resource: " . Data::Dumper::Dumper($row); # Debug output
        push @resources, $row;
    }

    # Pass the resources to the template
    $c->stash(resources => \@resources);
    $c->render(template => 'dashboard');
};


# Route: Display the Add Resource page
get '/addResource' => sub {
    my $c = shift;
    $c->render(template => 'addResource');
};

# Route: Add a new resource to the database
post '/addResource' => sub {
    my $c = shift;

    # Get form parameters
    my $name        = $c->param('name');
    my $description = $c->param('description');
    my $category    = $c->param('category');
    my $shared_with = $c->param('shared-with');
    my $session     = $c->param('session');
    my $resource_link = $c->param('resource-link');

    # Insert into database
    my $sth = $c->db->prepare("INSERT INTO resources (name, description, category, shared_with, session, resource_link)
                               VALUES (?, ?, ?, ?, ?, ?)");
    $sth->execute($name, $description, $category, $shared_with, $session, $resource_link);

    # Send a success response
    $c->render(json => { status => 'success', message => 'Resource added successfully!' });
};

# Route: Edit a specific resource
get '/editResource/:id' => sub {
    my $c = shift;
    my $id = $c->param('id');

    # Fetch the specific resource by ID
    my $sth = $c->db->prepare("SELECT * FROM resources WHERE id = ?");
    $sth->execute($id);
    my $resource = $sth->fetchrow_hashref;

    # Render the edit resource template
    if ($resource) {
        $c->stash(resource => $resource);
        $c->render(template => 'editResource');
    } else {
        $c->reply->not_found;
    }
};


app->static->paths->[0] = app->home->rel_file('public');

# Start the Mojolicious app
app->start;
