#!/usr/bin/perl -w

    print "\n    Perl version   : $]";
    print "\n    OS name        : $^O";
    print "\n    Module versions: (not all are required)\n";

    my @modules = qw(
                      Spreadsheet::WriteExcel
                      Parse::RecDescent
                      File::Temp
                      OLE::Storage_Lite
                      IO::Stringy
                    );

    for my $module (@modules) {
        my $version;
        eval "require $module";

        if (not $@) {
            $version = $module->VERSION;
            $version = '(unknown)' if not defined $version;
        }
        else {
            $version = '(not installed)';
        }

        printf "%21s%-24s\t%s\n", "", $module, $version;
    } 
