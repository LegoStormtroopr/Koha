#!/usr/bin/perl

# Copyright 2013 ByWater Solutions
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Koha is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Koha; if not, see <http://www.gnu.org/licenses>.

use Modern::Perl;

use CGI qw ( -utf8 );

use C4::Auth;
use C4::Output;
use Koha::List::Patron;

my $cgi = new CGI;

my ( $template, $logged_in_user, $cookie ) = get_template_and_user(
    {
        template_name   => "patron_lists/list.tt",
        query           => $cgi,
        type            => "intranet",
        authnotrequired => 0,
        flagsrequired => { tools => 'manage_patron_lists' },
    }
);

my ($list) =
  GetPatronLists( { patron_list_id => $cgi->param('patron_list_id') } );

my @patrons_to_add = $cgi->param('patrons_to_add');
if (@patrons_to_add) {
    AddPatronsToList( { list => $list, cardnumbers => \@patrons_to_add } );
}

my @patrons_to_remove = $cgi->param('patrons_to_remove');
if (@patrons_to_remove) {
    DelPatronsFromList( { list => $list, patron_list_patrons => \@patrons_to_remove } );
}

$template->param( list => $list );

output_html_with_http_headers( $cgi, $cookie, $template->output );
