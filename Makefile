# Download sample data
data: \
	data/sample.mdb \
	data/sample_fgdb.zip \
	data/sample.sid \
	data/sample_jpeg2000.zip \
	data/sample_ecw.zip

data/sample.mdb:
	curl -o data/sample.mdb "https://terra-data.s3.amazonaws.com/sample.mdb"

data/sample_fgdb.zip:
	curl -o data/sample_fgdb.zip "https://terra-data.s3.amazonaws.com/test_fgdb.zip"
	unzip -d data/ data/sample_fgdb.zip
	rm data/sample_fgdb.zip

data/sample.sid:
	curl -o data/sample.sid "https://terra-data.s3.amazonaws.com/67581.sid"

data/sample_jpeg2000.zip:
	curl -o data/sample_jpeg2000.zip "https://terra-data.s3.amazonaws.com/tc_baghdad_iq_jp2.zip"
	unzip -d data/ data/sample_jpeg2000.zip
	rm data/sample_jpeg2000.zip

data/sample_ecw.zip:
	curl -o data/sample_ecw.zip "https://terra-data.s3.amazonaws.com/tc_sanfrancisco_us_ecw.zip"
	unzip -d data/ data/sample_ecw.zip
	rm data/sample_ecw.zip

clean:
	rm -rf data/*
	@echo "Sample data removed."