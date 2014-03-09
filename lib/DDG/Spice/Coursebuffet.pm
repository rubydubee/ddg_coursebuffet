package DDG::Spice::Coursebuffet;
# ABSTRACT: Give the number of characters (length) of the query.

use DDG::Spice;
use File::Slurp;
use Switch;

my @course_titles = read_file('../../share/spice/coursebuffet/course_titles.txt');

triggers any => @course_titles;
triggers any => 'course','edx', 'coursera', 'udacity', 'saylor';

spice to => 'http://coursebuffet.com/ddg/$1';
spice wrap_jsonp_callback => 1;

handle remainder => sub {
  $text = $_;

  # Case for provider specific queries
  $text =~ /(coursera|edx|udacity|saylor)/;
  if($&) {
    $provider = $&;
    $query = $';
    $query =~ s/^\s+|\s+$//g;
    $query = uri_escape($query);
    return "provider/$provider/$query";
  }

  # Case for keyword 'course'
  $text =~ /course/;
  if($&) {
    $query = "";
    $query += $` if $`;
    $query += $' if $';
    $query =~ s/^\s+|\s+$//g;
    $query = uri_escape($query);
    return "provider/$provider/$query";
  }

  return;
};
1;
