class HelpCenter {
	final String? logoPath;
	final String? header;
	final String? tagline;
	final String description;
	final String phone;
	final String email;
	final String address;
	final String website;

	HelpCenter({
		this.logoPath,
		this.header,
		this.tagline,
		required this.description,
		required this.phone,
		required this.email,
		required this.address,
		required this.website,
	});

	factory HelpCenter.fromJson(Map<String, dynamic> json) {
		return HelpCenter(
			description: json['description'] ?? '',
			phone: json['phone_no'] ?? '',
			email: json['email'] ?? '',
			address: json['address'] ?? '',
			website: json['website'] ?? '',
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'description': description,
			'phone_no': phone,
			'email': email,
			'address': address,
			'website': website,
		};
	}
}
