use Test::Most;

{
  package MyApp::Controller::Example;
  $INC{'MyApp/Controller/Example.pm'} = __FILE__;

  use base 'Catalyst::Controller';
  use HTTP::Request::Common;
   
  sub as_http_request :Local {
    my ($self, $c) = @_;
    $c->redispatch_to(GET $c->uri_for($self->action_for('target')));
  }

  sub as_spec :Local {
    my ($self, $c) = @_;
    $c->redispatch_to(GET => $c->uri_for($self->action_for('target')));
  }

  sub target :Local {
    my ($self, $c) = @_;
    $c->response->content_type('text/plain');
    $c->response->body("This is the target action");
  }

  package MyApp;
  use Catalyst 'ResponseFrom';

  MyApp->setup;
}

use Catalyst::Test 'MyApp';

{
  my $res = request "/example/as_http_request";
  is $res->code, 200, 'OK';
  is $res->content, 'This is the target action', 'correct body';
}

{
  my $res = request "/example/as_spec";
  is $res->code, 200, 'OK';
  is $res->content, 'This is the target action', 'correct body';
}

done_testing;
