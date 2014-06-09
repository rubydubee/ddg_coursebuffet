package DDG::Spice::Coursebuffet;

use DDG::Spice;

spice to => 'http://www.coursebuffet.com/ddg/$1/$2';
spice from => '(.*?)/(.*)';
spice wrap_jsonp_callback => 1;

primary_example_queries "computer science course";
secondary_example_queries "computer science coursera";
description "Course catalog for online learning!";
name "CourseBuffet";

my @title_list = share('course_titles.txt')->slurp;
my @course_titles = ();
foreach my $title (@title_list) {
  chomp $title;
  push(@course_titles, $title);
}

triggers query_lc => qr/\s*/;

handle query_lc => sub {

  $_ =~ /(coursera|edx|udacity|saylor|novoed|futurelearn|iversity|open2study|openuped)/;
  if ($&) {
    return "provider", $&, "$` $'";
  }

  $_ =~ /course/;
  if ($&) {
    return "standard","courses", "$` $'";
  }

  my $query = $_;

  my @matches = grep { /^$query$/i } @course_titles;
  
  if(@matches) {
    return "title", "courses" ,$matches[0];
  } else {
    return;
  }

};

1;