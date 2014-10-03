Setup
=====
Requirements (for Windows):
* Rails: http://railsinstaller.org/en
* PostgreSQL: http://www.enterprisedb.com/products-services-training/pgdownload.
* Database "master-data-indonesia_development" for postgres

Commands
=====
Initial Setup:

    bundle
	rake db:migrate
	rake db:seed
	
Populate citizen data:

	rake fetcher:fetch_citizen_data
