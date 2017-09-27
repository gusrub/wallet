# Tokens

The tokens endpoint serves the purpose to provide the client user a safe way to either request a safe, expirable token to interact with the rest of the API or to change credentials such as a password reset.

Notice that tokens have an expiration date, depending on the type of token. Session tokens will last for 1 hour whereas password reset tokens will last for 1 day. If you get an unauthorized error you should request a new token.

## Create

> Roles: **admin**, **customer**

Creates a new token for the given type. You should use this endpoint to request a _"session"_ token so you can interact with the rest of the application.


### Request

`POST /tokens`

#### Headers

_None._

### Parameters

 - **[type]** *Required.* The type of the token to request. Can be either `session` or `password_reset`.
 - **[email]** *Required.* Email of the user to create the token for.
 - **[password]** *Optional.* Password for the user requesting the token. Only necessary when requesting a `session` type of token.

### Payload

```json
{
	"type": "session",
	"email": "john@example.com",
	"password": "S3cur3Pwd!"
}
```

### Response

`201 created`

```json
{
	"token": "pX27zsMN2ViQKta1bGfLmVJE",
	"type": "session",
	"uuid": "d31d73573a034830a1c6a995c4221d8d",
	"created_at": "2017-09-25 21:41:12 -0700",
	"expires_at": "2017-09-25 22:41:12 -0700"
}
```

#### Headers

_None._

# Users

The users endpoints allow interaction with user type resources and can be used to manage them. Although there are enpoints for all RESTful operations only a handful are available for regular users and are restricted for their own resource data. All other operations require admin permissions.

## Create

> Roles: **admin**

Creates a new user with the given data. This endpoint is restricted to admin operations.

### Request

`POST /users`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[email]** *Required*. The email of the new user account to create.
 - **[password]** *Optional*. A temporary password for the newly created user. If none is set, a random password will be generated.
 - **[first_name]** *Required.* The new user's first name.
 - **[last_name]** *Required.* The new user's last name.
 - **[role]** *Optional.* Role for the new user. This can be either `customer` or `admin`. If none is given it will fallback to a customer.
 - **[status]** *Optional.* The status of the user once created. Can be any of `active` to immediately have the user activated _(useful when providing password)_ `unconfirmed` if the user requires confirmation by email or `disabled` to create the user but have the account disabled to interact with the API. Fallsback to `unconfirmed` if none given.

### Payload

```json
{
	"email": "john@example.com",
	"password": "S3cur3Pwd!",
	"first_name": "John",
	"last_name": "Doe",
	"role": "customer",
	"status": "active"
}
```

### Response

`201 created`

```json
{
	"uuid": "d31d73573a034830a1c6a995c4221d8d",
	"email": "john@example.com",
	"first_name": "John",
	"last_name": "Doe",
	"role": "customer",
	"status": "unconfirmed",
	"created_at": "2017-09-25 21:41:12 -0700"
}
```

#### Headers

_None._

## Index

> Roles: **admin**

Lists current users in the system. Both `customer` and `admin` types. By default only the last 10 created records are returned. Parameters must be sent in order to retrieve the next pages. See below

### Request

`GET /users`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[page]** *Optional*. If set, will pull records for the given page. The response `X-Total-Pages` value can be used to discover how many pages are.

### Payload

_None._

### Response

`200 ok`

```json
[
	{
		"uuid": "d31d73573a034830a1c6a995c4221d8d",
		"email": "john@example.com",
		"first_name": "John",
		"last_name": "Doe",
		"role": "customer",
		"status": "unconfirmed",
		"created_at": "2017-09-25 21:41:12 -0700"
	},
	{
		"uuid": "7abeb64303b74fea8bb6e644913459cb",
		"email": "jane@example.com",
		"first_name": "Jane",
		"last_name": "Smith",
		"role": "admin",
		"status": "active",
		"created_at": "2017-09-25 21:41:12 -0700"
	}
]
```

#### Headers

 - **[X-Total-Pages]**. An integer containing the total amount of pages that the client can paginate through.

## Show

> Roles: **admin**, **customer**

Returns the details of a certain user. If the given user uuid is not the client's request user and the client's request user is a customer a `401 unauthorized` http error will be returned. Only admin users can retrieve details for all other users.

### Request

`GET /users/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[uuid]** *Required*. The unique ID of the user to retrieve.

### Payload

_None._

### Response

`200 ok`

```json
{
	"uuid": "d31d73573a034830a1c6a995c4221d8d",
	"email": "john@example.com",
	"first_name": "John",
	"last_name": "Doe",
	"role": "customer",
	"status": "unconfirmed",
	"created_at": "2017-09-25 21:41:12 -0700"
}
```

#### Headers

_None._

## Update

> Roles: **admin**, **customer**

Updates an existing user with the given data. This endpoint does not support updating a user's password or email and is only purpose is to update personal data for the user. If the requesting user is an admin it can change any other user's data, otherwise it can only change the requesting user's data. Trying to change other's user's data with a `customer` role will cause a `401 unauthorized` http error.

### Request

`PATCH /users/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[first_name]** *Optional.* The updated user first name.
 - **[last_name]** *Optional.* The updated user last name.
 - **[role]** *Optional.* Role for the updated user. This can be either `customer` or `admin`.
 - **[status]** *Optional.* The status of the user. Can be any of `active`, `unconfirmed` if the user requires confirmation by email or `disabled` to disable the user.

### Payload

```json
{
	"first_name": "John",
	"last_name": "Doe",
	"role": "customer",
	"status": "disabled",
}
```

### Response

`200 ok`

```json
{
	"uuid": "d31d73573a034830a1c6a995c4221d8d",
	"email": "john@example.com",
	"first_name": "John",
	"last_name": "Doe",
	"role": "customer",
	"status": "unconfirmed",
	"created_at": "2017-09-25 21:41:12 -0700"
}
```

#### Headers

_None._

## Delete

> Roles: **admin**

Removes an existing user from the system. This endpoint is only accesible by `admin` users. Do note that if a user has existing transactions an error will be returned and instead the user must be disabled or _soft deleted_ to keep integrity of data.

### Request

`DELETE /users/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[uuid]** *Required.* The unique ID of the user to delete.

### Payload

_None._

### Response

`203 no content`

_None_.

#### Headers

_None._

# Transactions

Transactions are the basis of the wallet system. A transaction represents an operation between entities that affects balances of both sides, even for operations not involving electronic money. For instance, a _wallet_ to _wallet_ transfer of electronic money is the most common, however, there are other operations that a user can do such as recharging the wallet or withdrawing the money.

These transactions are always made on behalf of the calling client wallet, that is, all created transactions happen because one of the ends is the client's wallet.

For these transactions there exist different types of operations:

 1. A wallet to wallet transfer. For instance, customer John Doe transfering e-money to Jane Smith.
 2. A wallet deposit, that is, when the customer wishes to add credit to the wallet from a debit or a credit card.
 3. A wallet withdrawal, when the customer wants to move money away from the wallet outside the system to a debit or a credit card.

There are another two types of operations which cannot be created by the user but can appear on balances and they happen internally and automatically:

 1. A flat fee that is applied when a wallet to wallet operation occurs, where the payee is charged such amount. The fee depends on the amount being transfered and these fees can be consulted in the `fees` endpoint.
 2. A variable rate fee which is applied when a wallet to wallet operation occurs, where the payee is charged such amount which is calculated as the `(amount x rate)`. The fee depends on the amount being transfered and these fees can be consulted in the `fees` endpoint.

Client can provide an amount and a description for the transfer so it reminds of the reason of the operation.

Once an operation suceeds the current balance will be stored for historial reasons and to generate a useful statement. There is a field called `reference` which is used internally and will store a reference to a parent transaction in the case that the transaction was the consequence of another which is the case of the fees.

Since transactions are related to real money they cannot be deleted once they have been succesful. For such purpose a dispute process should be done where the target entity that received the money creates another operation to balance the account again in the principles of banking and financial systems. The only attribute that could be modified once a transaction is done is the `description` which is mostly for the end-user purposes and does not affect the balances.

## Create

> Roles: **admin**, **customer**

Creates a new transaction for the given type and the given amount. This transaction is executed on behalf of the user passed as parameter so if the calling client is not the user of the resource the endpoint will return a `401 unauthorized` http error unless the calling client is an `admin` 

In order to create transactions the client must provide the type of transaction that needs to be executed which is limited to the ones that are available to wallets being:

 - `transfer` transfer money from the calling client to another customer wallet.
 - `deposit` charge the wallet from an existing credit or debit card from the customer.
 - `withdrawal` move money from the wallet to a customer's debit or credit card.

The other two types are not available for use, that is `flat_fee` and `variable_fee` since they are created or triggered by other transactions automatically. These are not even available for admin users.

Depending on the type of transaction the client must provide the ID of a _"transactionable"_ object which can be either a wallet from another user for transfers between users or a card from the calling client in case of a deposit or withdrawal. Naturally, a client can only transfer money from his/her wallet to another and not the other way around and can also only withdraw from or deposit to his/her own cards. 

For operations that involve interaction with 3rd parties such as other banks if a problem occurs on the third party a `502 bad gateway` error will be returned. This is a possible scenario if there is a downtime or connection problem to the credit or debit card issuer. Also note that insuficient funds or problems with the account itself do not account as gateway problems.

Finally, an important thing to consider is that the calling client must have enough funds on the wallet for the operation to succeeed in the case of wallet-to-wallet transfer because of the fees considering that the operation is actually the desired transfer amount + fees. If there are not enough funds then the request will fail.

### Request

`POST /users/:uuid/transactions`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[amount]** *Required*. The amount to be transfered to the other account.
 - **[type]** *Required*. The type of transaction desired. Can be either `transfer`, `deposit` or `withdrawal`.
 - **[description]** *Optional*. A user description of the reason of the operation. For statement purposes.
 - **[transactionable][uuid]** *Required.* The unique ID of the transactionable object which can be a `card` or `wallet`.

### Payload

```json
{
	"amount": 1500.00,
	"type": "transfer",
	"description": "Payment for service",
	"transactionable" : {
		"uuid" : "210c9ff2a2134d2e982baee5d694cce3"
	}
}
```

### Response

`201 created`

```json
{
	"uuid": "d31d73573a034830a1c6a995c4221d8d",
	"amount": 1500.00,
	"type": "transfer",
	"description": "Payment for service",
	"transactionable" : {
		"uuid" : "210c9ff2a2134d2e982baee5d694cce3"
	}
	"reference": null,
	"balance": 25000.00,
	"created_at": "2017-09-25 21:41:12 -0700"
}
```

#### Headers

_None._

## Index

> Roles: **admin**, **customer**

Lists the transactions for the given user. By default only the last 10 created records are returned. Parameters must be sent in order to retrieve the next pages. See below

### Request

`GET /users/:user_uuid/transations`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[user_uuid]** *Required*. The unique ID of the user whose transactions are to be retrieved.
 - **[page]** *Optional*. If set, will pull records for the given page. The response `X-Total-Pages` value can be used to discover how many pages are.

### Payload

_None._

### Response

`200 ok`

```json
[
	{
		"uuid": "d31d73573a034830a1c6a995c4221d8d",
		"amount": 1000.00,
		"type": "transfer",
		"description": "Payment for service",
		"transactionable" : {
			"uuid" : "210c9ff2a2134d2e982baee5d694cce3"
		}
		"reference": null,
		"balance": 2000.00,
		"created_at": "2017-09-25 21:41:12 -0700"
	},
	{
		"uuid": "7564f3279cd64e0f999c33d45866e676",
		"amount": 8.00,
		"type": "flat_fee",
		"description": "Transfer flat fee",
		"reference": "d31d73573a034830a1c6a995c4221d8d",
		"balance": 1992.00,
		"created_at": "2017-09-25 21:41:12 -0700"
	},
	{
		"uuid": "7564f3279cd64e0f999c33d45866e676",
		"amount": 30.00,
		"type": "flat_fee",
		"description": "Variable fee (3%)",
		"reference": "d31d73573a034830a1c6a995c4221d8d",
		"balance": 1962.00,
		"created_at": "2017-09-25 21:41:12 -0700"
	}	
]
```

#### Headers

 - **[X-Total-Pages]**. An integer containing the total amount of pages that the client can paginate through.

## Show

> Roles: **admin**, **customer**

Returns the details of a certain transaction. If the given user uuid is not the client's request user and the client's request user is a customer a `401 unauthorized` http error will be returned. Only admin users can retrieve details for all other user transactions.

### Request

`GET /users/:user_uuid/transations/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[user_uuid]** *Required*. The unique ID of the user whose transaction is to be retrieved.
 - **[uuid]** *Required*. The unique ID of the user transaction.

### Payload

_None._

### Response

`200 ok`

```json
{
	"uuid": "d31d73573a034830a1c6a995c4221d8d",
	"amount": 1000.00,
	"type": "transfer",
	"description": "Payment for service",
	"transactionable" : {
		"uuid" : "210c9ff2a2134d2e982baee5d694cce3"
	}
	"reference": null,
	"balance": 2000.00,
	"created_at": "2017-09-25 21:41:12 -0700"
}
```

#### Headers

_None._

## Update

> Roles: **admin**, **customer**

Allows the client to update the description of a transaction. Trying to change other's user's data with a `customer` role will cause a `401 unauthorized` http error.

### Request

`PATCH /users/:user_uuid/transactions/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[user_uuid]** *Required*. The unique ID of the user whose transaction is to be updated.
 - **[uuid]** *Required*. The unique ID of the user transaction.

### Payload

```json
{
	"description": "A newer description"
}
```

### Response

`200 ok`

```json
{
	"uuid": "d31d73573a034830a1c6a995c4221d8d",
	"amount": 1000.00,
	"type": "transfer",
	"description": "A newer description",
	"transactionable" : {
		"uuid" : "210c9ff2a2134d2e982baee5d694cce3"
	}
	"reference": null,
	"balance": 2000.00,
	"created_at": "2017-09-25 21:41:12 -0700"
}
```

#### Headers

_None._

# Cards

Cards are used in the system for two purposes mainly: to transfer money to or from the wallet. A card can be either a credit or debit card regardless of the bank.

While a wallet does not need a card, it is the only way to charge the wallet unless another user transfers money to the other user wallet. Also, to withdraw the money the user would need a card that the money can be transfered to.

Although initially the whole set of data from the card is requested we do not store it for security reasons. The only data that will be stored are the last 4 digits to keep a reference for statement purposes and also the expiration date to notify the user whenever the card is about to expire or in the case that a transaction is to be made with a card that has expired to avoid costs involved with failed charges common on financial systems.

Also, a card cannot be modified. If a user wishes to edit data from a card then the card needs to be removed and added back.

Lastly, if the card has been already involved in transactions a _soft delete_ is going to happen in order to keep integrity of the data. Since no personal information is stored from the cards there is no concern of data at store even if the customer decided to remove the card. The field `status` will set this and it can be either `active` or `removed`.

## Create

> Roles: **admin**, **customer**

Creates a new card with the given data. Card will be tested against issuer for validity when added but not for funds as no charge will be done. A card can be either a credit or debit card. 

### Request

`POST /users/:user_uuid/cards`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[name_on_card]** *Required*. The name as it appears in the card.
 - **[number]** *Required*. Card number digits.
 - **[csc]** *Required*. Card security code.
 - **[expiration_year]** *Required*. Card expiration year.
 - **[expiration_month]** *Required*. Card expiration month.
 - **[type]** *Required.* Can be either `debit` or `credit`.

### Payload

```json
{
	"name_on_card": "John Doe",
	"number": "4111111111111111",
	"csc": "123",
	"expiration_year": "2020",
	"expiration_month": "06",
	"type": "credit"
}
```

### Response

`201 created`

```json
{
	"uuid": "a72bcca65e8d422b96d3ad5cffe92373",
	"last_4": "1111",
	"type": "credit",
	"expiration_year": "2020",
	"expiration_month": "06",
	"issuer": "visa",
	"status": "active",
	"created_at": "2017-09-25 22:57:50 -0700"
}
```

#### Headers

_None._

## Index

> Roles: **admin**, **customer**

Lists all the active cards for the given user. If the requesting client is a `customer` it will default to active cards, `admin` users can list also inactive cards for historical purposes. By default only the last 10 created records are returned. Parameters must be sent in order to retrieve the next pages. See below

### Request

`GET /users/:user_uuid/cards`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[user_uuid]** *Required*. The unique ID of the user whose cards are to be retrieved.
 - **[page]** *Optional*. If set, will pull records for the given page. The response `X-Total-Pages` value can be used to discover how many pages are.

### Payload

_None._

### Response

`200 ok`

```json
[
	{
		"uuid": "a72bcca65e8d422b96d3ad5cffe92373",
		"last_4": "1111",
		"type": "credit",
		"expiration_year": "2020",
		"expiration_month": "06",
		"issuer": "visa",
		"status": "active",
		"created_at": "2017-09-25 22:57:50 -0700"
	},
	{
		"uuid": "55a78a5d81664ffb8bfeb8125512bcc2",
		"last_4": "5100",
		"type": "debit",
		"expiration_year": "2021",
		"expiration_month": "11",
		"issuer": "mastercard",
		"status": "removed",
		"created_at": "2017-09-25 22:57:50 -0700"
	}
]
```

#### Headers

 - **[X-Total-Pages]**. An integer containing the total amount of pages that the client can paginate through.

## Show

> Roles: **admin**, **customer**

Returns the details of a certain transaction. If the given user uuid is not the client's request user and the client's request user is a customer a `401 unauthorized` http error will be returned. Only admin users can retrieve details for all other user transactions.

### Request

`GET /users/:user_uuid/cards/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[user_uuid]** *Required*. The unique ID of the user whose card is to be retrieved.
 - **[uuid]** *Required*. The unique ID of the user card.

### Payload

_None._

### Response

`200 ok`

```json
{
	"uuid": "a72bcca65e8d422b96d3ad5cffe92373",
	"last_4": "1111",
	"type": "credit",
	"expiration_year": "2020",
	"expiration_month": "06",
	"issuer": "visa",
	"status": "active",
	"created_at": "2017-09-25 22:57:50 -0700"
}
```

#### Headers

_None._

## Delete

> Roles: **admin**, **customer**

Removes an existing card from a user on the system. If there are any transactions on the card already then the card is _soft deleted_ and its status is set to `removed` instead meaning that it won't appear anymore for the user but `admin` users can still see them.

### Request

`DELETE /users/:user_uuid/cards/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[user_uuid]** *Required.* The unique ID of the user to whose card is to be removed.
 - **[uuid]** *Required.* The unique ID of the user's card to delete.

### Payload

_None._

### Response

`203 no content`

_None_.

#### Headers

_None._


# Fees

Fees are objects that set how much is charged per each transaction, particularily those between wallets. Each transaction will have both a flat fee charge and a variable rate fee calculated from the transfer amount. These fees are then withdrawn from the customer's wallet.

These fees are basically upper and lower bounds for amounts tied to the fee amount and the variable rate or ranges. These endpoints are all for administrative purposes so no regular `customer` type of account can access them.

Fee records do not have relation between transactions and instead the historic balance field and description are used to store at a certain point of time this information as rates may change with time.

## Create

> Roles: **admin**

Creates a new fee.

### Request

`POST /fees`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[lower_range]** *Required*. The lower range for this fee.
 - **[upper_range]** *Required*. The upper range for this fee.
 - **[flat_fee]** *Required*. The flat fee for this range.
 - **[variable_rate]** *Required*. The variable rate fee.

### Payload

```json
{
	"lower_range": 0,
	"upper_range": 1000.00,
	"flat_fee": 8.00,
	"variable_rate": 3.0
}
```

### Response

`201 created`

```json
{
	"uuid": "388175dc546c4c7f90d91121ebe83368",
	"lower_range": 0,
	"upper_range": 1000.00,
	"flat_fee": 8.00,
	"variable_rate": 3.0
	"created_at": "2017-09-25 22:57:50 -0700"
}
```

#### Headers

_None._

## Index

> Roles: **admin**, **customer**

Lists all the fee ranges in the system. By default only the last 10 created records are returned. Parameters must be sent in order to retrieve the next pages. See below

### Request

`GET /fees`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[page]** *Optional*. If set, will pull records for the given page. The response `X-Total-Pages` value can be used to discover how many pages are.

### Payload

_None._

### Response

`200 ok`

```json
[
	{
		"uuid": "388175dc546c4c7f90d91121ebe83368",
		"lower_range": 0,
		"upper_range": 1000.00,
		"flat_fee": 8.0,
		"variable_rate": 3.0
		"created_at": "2017-09-25 22:57:50 -0700"
	},
	{
		"uuid": "9c7a0ace7d1d49e1bbde23018fc8d0b6",
		"lower_range": 1001.00,
		"upper_range": 5000.00,
		"flat_fee": 20.00,
		"variable_rate": 5.0
		"created_at": "2017-09-25 22:57:50 -0700"
	}
]
```

#### Headers

 - **[X-Total-Pages]**. An integer containing the total amount of pages that the client can paginate through.

## Show

> Roles: **admin**

Returns the details for a fee.

### Request

`GET /fees/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[uuid]** *Required*. The unique ID of the fee.

### Payload

_None._

### Response

`200 ok`

```json
{
	"uuid": "388175dc546c4c7f90d91121ebe83368",
	"lower_range": 0,
	"upper_range": 1000.00,
	"flat_fee": 8.00,
	"variable_rate": 3.00
	"created_at": "2017-09-25 22:57:50 -0700"
}
```

#### Headers

_None._

## Delete

> Roles: **admin**

Removes a fee from the system.

### Request

`DELETE /fees/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[uuid]** *Required.* The unique ID of the fee to delete.

### Payload

_None._

### Response

`203 no content`

_None_.

#### Headers

_None._

## Update

> Roles: **admin**

Updates an existing fee.

### Request

`PATCH /fees/:uuid`

#### Headers

 - **[Accept]** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **[Content-Type]** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **[X-User-Email]** *Required*. The email of the user account making the request.
 - **[X-User-Token]** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **[lower_range]** *Optional*. The lower range for this fee.
 - **[upper_range]** *Optional*. The upper range for this fee.
 - **[flat_fee]** *Optional*. The flat fee for this range.
 - **[variable_rate]** *Optional*. The variable rate fee.

### Payload

```json
{
	"lower_range": 0,
	"upper_range": 1000.00,
	"flat_fee": 8.00,
	"variable_rate": 4.5
}
```

### Response

`200 ok`

```json
{
	"uuid": "388175dc546c4c7f90d91121ebe83368",
	"lower_range": 0,
	"upper_range": 1000.00,
	"flat_fee": 8.00,
	"variable_rate": 4.5
	"created_at": "2017-09-25 22:57:50 -0700"
}
```

#### Headers

_None._
