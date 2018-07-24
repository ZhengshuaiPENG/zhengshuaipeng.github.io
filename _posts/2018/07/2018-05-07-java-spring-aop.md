---
layout: post
title:  "[JAVA_Spring] How to POST with Spring RestTemplate"
date:   2018-07-24
desc: "POST with Spring RestTemplate"
keywords: "java, spring, AOP"
categories: [spring]
---

# I. Post with RestTemplate

We can use Spring RestTemplate class to post a request to a remote Service API. Basically, we could pass an Java Bean Object as a POST body which could be serialized to a JSON.

Assume that there is a API url which provided by a remote sevice, it requires a JSON string as post body. This json string is serialized from BeanObject. 

To invoke this API, we need to set the HTTP header first with the ContentType set to JSON. Then construct a HttpEntity with this header and the instance of class BeanObject.

The code shows as below:

```java
@Autowired
@Qualifier("restTemplate")
private RestTemplate restTemplate;

public ResponseStatus postRequest(BeanObject requestObj, String apiUrl){
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    HttpEntity<BeanObject> reqeust = new HttpEntity<>(requestObj, headers);
    ResponseStatus responseStatus = restTemplate.postForObject(url, request, ResponseStatus.class);
    return responseStatus;
}
```

