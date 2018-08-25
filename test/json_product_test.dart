
import 'package:http/http.dart' as http;
import 'package:virga_shop/models/product.dart';
import 'dart:convert';

void main(){

 String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE1MzQ4ODA3MDcsImV4cCI6MTUzNDg4NDMwNywicm9sZXMiOlsiUk9MRV9SRVRBSUxFUiJdLCJwaG9uZSI6IjgxMjM2MzA2MDgifQ.Awd0YcmmFjctG9UczCtZGMCE41fmGVoZjabhnzTd78fOcIMa2qqppv3Gq_03FWoVztEzZwYaXQvwnfGqwl2P9wz2gAWckEXFARDQwotZdXGALSwNR8R9zaS9ON4Cw7gUXRNyu5mxLnkZVwUX5HSS_W8Y1tFvixGmIYP6w5LT0PygMXrAWHmPW_jVPOOiI3JP1A1E_Z6QmmKeg_wkL0YrWjUud52D6HfMsfCvAtLiX-dz5Sri2YJLJa0DdIjUpyHr2SIuIWo35SG6A-zoBB31ZWOAjcmx6wve-rrDD6AE_acDN2qu8IUyXFvJUP0oG7NFND0cgTV-a3irdpnfhfOLQpXTvSzWVuNVLXsUc7NRSVOU9KvNmss13DyyWvj6wsa_S48kRTn34rHMACFKIINjrfVHHR72dzU-rOVdZH0UaTZqQV-k-PEzFhznXA1hPqJsMkePlgyy-qxwCqMmtenfV4X_jY1ZwyCy_755yncmNwfCx2iV0bRdw1JjCiXky45yrDqLacXhueOVC-NtJRwTnoOini-089LWKKtw6FqqoOykc5WIOuGMaud1HAJ3n2y75HmPPBuYGYqIqsVzw1a8SZVlmNCQjf99UR-V7iX2QITMOsqmhwik-cG5DP3Tv9OSZ0t2DpnKvu2YD0gmA3dhXQ7BkGn_avkZIN94YpqYyRY';

      String url = "http://localhost/VirgaMongo/public/api/products/5b7c5669e05f06392400093e";

      Map<String, String> headers = {"Authorization": "Bearer $token"};

    http.get(url,headers:headers).then((onValue){

      Product product = Product.fromJson(jsonDecode(onValue.body));

      print(product.toString());

  });
}