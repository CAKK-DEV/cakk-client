regenerate:
	make clean
	tuist generate

clean:
	rm -rf	rm -rf **/**/*.xcodeproj
	rm -rf **/**/Derived
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/**/Derived
	rm -rf *.xcworkspace

generate:
	tuist install
	tuist generate
