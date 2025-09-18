CREATE PROCEDURE [dbo].[Marker437]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

MERGE INTO [dbo].[Country] AS Target 
	USING (VALUES 
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+247', 'Ascension Island'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+376', 'Andorra'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+971', 'United Arab Emirates'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+93', 'Afghanistan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Antigua and Barbuda'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Anguilla'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+355', 'Albania'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+374', 'Armenia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+244', 'Angola'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+54', 'Argentina'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'American Samoa'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+43', 'Austria'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+61', 'Australia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+297', 'Aruba'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+358', 'Åland Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+994', 'Azerbaijan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+387', 'Bosnia and Herzegovina'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Barbados'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+880', 'Bangladesh'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+32', 'Belgium'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+226', 'Burkina Faso'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+359', 'Bulgaria'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+973', 'Bahrain'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+257', 'Burundi'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+229', 'Benin'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+590', 'Saint Barthélemy'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Bermuda'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+673', 'Brunei'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+591', 'Bolivia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+599', 'Bonaire, Sint Eustatius and Saba'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+55', 'Brazil'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Bahamas'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+975', 'Bhutan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+267', 'Botswana'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+375', 'Belarus'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+501', 'Belize'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Canada'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+61', 'Cocos Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+243', 'The Democratic Republic Of Congo'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+236', 'Central African Republic'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+242', 'Congo'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+41', 'Switzerland'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+225', 'Côte d''Ivoire'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+682', 'Cook Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+56', 'Chile'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+237', 'Cameroon'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+86', 'China'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+57', 'Colombia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+506', 'Costa Rica'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+53', 'Cuba'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+238', 'Cape Verde'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+599', 'Curaçao'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+61', 'Christmas Island'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+357', 'Cyprus'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+420', 'Czech Republic'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+49', 'Germany'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+253', 'Djibouti'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+45', 'Denmark'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Dominica'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Dominican Republic'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+213', 'Algeria'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+593', 'Ecuador'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+372', 'Estonia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+20', 'Egypt'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+212', 'Western Sahara'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+291', 'Eritrea'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+34', 'Spain'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+251', 'Ethiopia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+358', 'Finland'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+679', 'Fiji'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+500', 'Falkland Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+691', 'Micronesia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+298', 'Faroe Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+33', 'France'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+241', 'Gabon'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+44', 'United Kingdom'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Grenada'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+995', 'Georgia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+594', 'French Guiana'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+44', 'Guernsey'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+233', 'Ghana'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+350', 'Gibraltar'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+299', 'Greenland'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+220', 'Gambia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+224', 'Guinea'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+590', 'Guadeloupe'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+240', 'Equatorial Guinea'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+30', 'Greece'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+502', 'Guatemala'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Guam'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+245', 'Guinea-Bissau'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+592', 'Guyana'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+852', 'Hong Kong'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+504', 'Honduras'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+385', 'Croatia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+509', 'Haiti'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+36', 'Hungary'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+62', 'Indonesia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+353', 'Ireland'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+972', 'Israel'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+44', 'Isle Of Man'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+91', 'India'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+246', 'British Indian Ocean Territory'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+964', 'Iraq'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+98', 'Iran'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+354', 'Iceland'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+39', 'Italy'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+44', 'Jersey'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Jamaica'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+962', 'Jordan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+81', 'Japan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+254', 'Kenya'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+996', 'Kyrgyzstan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+855', 'Cambodia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+686', 'Kiribati'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+269', 'Comoros'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Saint Kitts And Nevis'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+850', 'North Korea'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+82', 'South Korea'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+965', 'Kuwait'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Cayman Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+7', 'Kazakhstan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+856', 'Laos'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+961', 'Lebanon'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Saint Lucia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+423', 'Liechtenstein'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+94', 'Sri Lanka'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+231', 'Liberia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+266', 'Lesotho'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+370', 'Lithuania'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+352', 'Luxembourg'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+371', 'Latvia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+218', 'Libya'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+212', 'Morocco'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+377', 'Monaco'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+373', 'Moldova'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+382', 'Montenegro'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+590', 'Saint Martin'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+261', 'Madagascar'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+692', 'Marshall Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+389', 'Macedonia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+223', 'Mali'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+95', 'Myanmar'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+976', 'Mongolia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+853', 'Macao'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Northern Mariana Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+596', 'Martinique'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+222', 'Mauritania'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Montserrat'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+356', 'Malta'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+230', 'Mauritius'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+960', 'Maldives'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+265', 'Malawi'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+52', 'Mexico'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+60', 'Malaysia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+258', 'Mozambique'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+264', 'Namibia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+687', 'New Caledonia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+227', 'Niger'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+672', 'Norfolk Island'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+234', 'Nigeria'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+505', 'Nicaragua'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+31', 'Netherlands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+47', 'Norway'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+977', 'Nepal'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+674', 'Nauru'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+683', 'Niue'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+64', 'New Zealand'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+968', 'Oman'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+507', 'Panama'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+51', 'Peru'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+689', 'French Polynesia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+675', 'Papua New Guinea'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+63', 'Philippines'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+92', 'Pakistan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+48', 'Poland'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+508', 'Saint Pierre And Miquelon'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Puerto Rico'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+970', 'Palestine'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+351', 'Portugal'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+680', 'Palau'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+595', 'Paraguay'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+974', 'Qatar'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+262', 'Reunion'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+40', 'Romania'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+381', 'Serbia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+7', 'Russia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+250', 'Rwanda'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+966', 'Saudi Arabia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+677', 'Solomon Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+248', 'Seychelles'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+249', 'Sudan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+46', 'Sweden'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+65', 'Singapore'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+290', 'Saint Helena'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+386', 'Slovenia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+47', 'Svalbard And Jan Mayen'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+421', 'Slovakia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+232', 'Sierra Leone'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+378', 'San Marino'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+221', 'Senegal'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+252', 'Somalia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+597', 'Suriname'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+211', 'South Sudan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+239', 'Sao Tome And Principe'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+503', 'El Salvador'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Sint Maarten (Dutch part)'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+963', 'Syria'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+268', 'Swaziland'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'0', 'Tristan da Cunha'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Turks And Caicos Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+235', 'Chad'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+228', 'Togo'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+66', 'Thailand'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+992', 'Tajikistan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+690', 'Tokelau'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+670', 'Timor-Leste'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+993', 'Turkmenistan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+216', 'Tunisia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+676', 'Tonga'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+90', 'Turkey'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Trinidad and Tobago'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+688', 'Tuvalu'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+886', 'Taiwan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+255', 'Tanzania'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+380', 'Ukraine'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+256', 'Uganda'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'United States'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+598', 'Uruguay'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+998', 'Uzbekistan'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+39', 'Vatican'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'Saint Vincent And The Grenadines'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+58', 'Venezuela'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'British Virgin Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+1', 'U.S. Virgin Islands'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+84', 'Vietnam'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+678', 'Vanuatu'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+681', 'Wallis And Futuna'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+685', 'Samoa'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+383', 'Kosovo'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+967', 'Yemen'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+262', 'Mayotte'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+27', 'South Africa'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+260', 'Zambia'),
(newid(),@CompanyId,@UserId,NULL,GetDate(),'+263', 'Zimbabwe'))
AS Source ([Id], [CompanyId],[CreatedByUserId],[InactiveDateTime],[CreatedDateTime], [CountryCode] ,[CountryName])
	ON Target.[CountryName] = Source.[CountryName]  AND Target.[CompanyId] = Source.[CompanyId] 
	WHEN MATCHED THEN 
	UPDATE SET
			   [CountryName] = Source.[CountryName],
			   [CountryCode] = Source.[CountryCode]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId],[CreatedByUserId],[InactiveDateTime],[CreatedDateTime],[CountryCode], [CountryName])
	VALUES ([Id], [CompanyId],[CreatedByUserId],[InactiveDateTime],[CreatedDateTime],[CountryCode], [CountryName]);

MERGE INTO [dbo].[Currency] AS Target 
	USING (VALUES 
 (NewId(),@companyId,@UserId,null,Getdate(),  'Leke', 'ALL', 'Lek')

 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Afghanis', 'AFN', '؋')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pesos', 'ARS', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Guilders', 'AWG', 'ƒ')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'AUD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'New Manats', 'AZN', 'ман')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'BSD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rubles', 'BYR', 'p.')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'BZD', 'BZ$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'BMD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),   'Bolivianos', 'BOB', '$b')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Convertible Marka', 'BAM', 'KM')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pula', 'BWP', 'P')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Leva', 'BGN', 'лв')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Reais', 'BRL', 'R$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'BND', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Riels', 'KHR', '៛')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Dollars', 'CAD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate() , 'Dollars', 'KYD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pesos', 'CLP', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Yuan Renminbi', 'CNY', '¥')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Pesos', 'COP', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Colón', 'CRC', '₡')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Kuna', 'HRK', 'kn')
 ,(NewId(),@companyId,@UserId,null,Getdate(),   'Pesos', 'CUP', '₱')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Koruny', 'CZK', 'Kč')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Kroner', 'DKK', 'kr')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pesos', 'DOP ', 'RD$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'XCD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pounds', 'EGP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Colones', 'SVC', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pounds', 'FKP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Dollars', 'FJD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Cedis', 'GHC', '¢')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pounds', 'GIP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate() , 'Quetzales', 'GTQ', 'Q')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Pounds', 'GGP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'GYD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Lempiras', 'HNL', 'L')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'HKD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Forint', 'HUF', 'Ft')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Kronur', 'ISK', 'kr')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rupees', 'INR', 'Rp')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rupiahs', 'IDR', 'Rp')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rials', 'IRR', '﷼')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pounds', 'IMP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'New Shekels', 'ILS', '₪')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'JMD', 'J$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Yen', 'JPY', '¥')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pounds', 'JEP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Tenge', 'KZT', 'лв')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Won', 'KRW', '₩')
 ,(NewId(),@companyId,@UserId,null,Getdate() , 'Soms', 'KGS', 'лв')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Kips', 'LAK', '₭')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Lati', 'LVL', 'Ls')
 ,(NewId(),@companyId,@UserId,null,Getdate(),'Pounds', 'LBP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(),'Dollars', 'LRD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Switzerland Francs', 'CHF', 'CHF')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Litai', 'LTL', 'Lt')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Denars', 'MKD', 'ден')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Ringgits', 'MYR', 'RM')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rupees', 'MUR', '₨')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pesos', 'MXN', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Tugriks', 'MNT', '₮')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Meticais', 'MZN', 'MT')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Dollars', 'NAD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Rupees', 'NPR', '₨')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Guilders', 'ANG', 'ƒ')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Euro', 'EUR', '€')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Cordobas', 'NIO', 'C$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Nairas', 'NGN', '₦')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Krone', 'NOK', 'kr')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Rials', 'OMR', '﷼')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rupees', 'PKR', '₨')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Balboa', 'PAB', 'B/.')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Guarani', 'PYG', 'Gs')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Nuevos Soles', 'PEN', 'S/.')
 ,(NewId(),@companyId,@UserId,null,Getdate() , 'Pesos', 'PHP', 'Php')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Zlotych', 'PLN', 'zł')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rials', 'QAR', '﷼')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'New Lei', 'RON', 'lei')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rubles', 'RUB', 'руб')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pounds', 'SHP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Riyals', 'SAR', '﷼')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Dinars', 'RSD', 'Дин.')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rupees', 'SCR', '₨')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'SGD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'SBD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Shillings', 'SOS', 'S')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rand', 'ZAR', 'R')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Rupees', 'LKR', '₨')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Kronor', 'SEK', 'kr')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Francs', 'CHF', 'CHF')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Dollars', 'SRD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),  'Pounds', 'SYP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'New Dollars', 'TWD', 'NT$')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Baht', 'THB', '฿')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Dollars', 'TTD', 'TT$')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Lira', 'TRY', 'TL')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Liras', 'TRL', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Dollars', 'TVD', '$')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Hryvnia', 'UAH', '₴')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Pounds', 'GBP', '£')
 ,(NewId(),@companyId,@UserId,null,Getdate(),'Pesos', 'UYU', '$U')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Sums', 'UZS', 'лв')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Bolivares Fuertes', 'VEF', 'Bs')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Dong', 'VND', '₫')
 ,(NewId(),@companyId,@UserId,null,Getdate(),'Rials', 'YER', '﷼')
 ,(NewId(),@companyId,@UserId,null,Getdate(), 'Zimbabwe Dollars', 'ZWD', 'Z$')
 ,(NewId(),@companyId,@UserId,null,Getdate(),'Rupees', 'INR', '₹')
 )
 AS Source ([Id], [CompanyId],[CreatedByUserId],[InactiveDateTime],[CreatedDateTime], CurrencyCode,CurrencyName,Symbol)
	ON Target.[CurrencyName] = Source.[CurrencyName] AND Target.[CompanyId] = Source.[CompanyId]   AND Target.CurrencyCode = Source.CurrencyCode  AND Target.Symbol = Source.Symbol   
	WHEN MATCHED THEN 
	UPDATE SET
			   [CompanyId] = Source.[CompanyId],
			   CurrencyCode = Source.CurrencyCode,
			   CurrencyName = Source.CurrencyName,
			   Symbol = Source.Symbol
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId],[CreatedByUserId],[InactiveDateTime],[CreatedDateTime], CurrencyCode,CurrencyName,Symbol)
	VALUES ([Id], [CompanyId],[CreatedByUserId],[InactiveDateTime],[CreatedDateTime], CurrencyCode,CurrencyName,Symbol);

UPDATE TradeTemplateType SET FormJson = '{"components":[{"label":"Vessel Owner","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"autofocus":false,"disabled":false,"tableView":false,"displayAs":"dropdown_single_select","importDataType":"form","formName":"52241ba0-77c4-4591-be6a-de2f04eeb1dd","fieldName":"contractNumber","valueSelection":"latest","relatedfield":["voyageNumber","commodityName","vesselOwnerAddressLine1"],"relatedForm":[],"relatedFormsFields":[],"validate":{"required":false,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"validateOn":"change","errorLabel":"","key":"vesselOwner","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"mylookup","input":true,"selectedFormName":"Vessel - test","selectedFormId":"52241ba0-77c4-4591-be6a-de2f04eeb1dd","relatedFieldsLabel":["Voyage Number","Commodity Name","Vessel Owner Address-Line 1"],"relatedFieldsData1":[{"FormName":"Vessel - test","KeyName":"voyageNumber","label":"Voyage Number"},{"FormName":"Vessel - test","KeyName":"commodityName","label":"Commodity Name"},{"FormName":"Vessel - test","KeyName":"vesselOwnerAddressLine1","label":"Vessel Owner Address-Line 1"}],"relatedFieldsfinalData":[{"FormName":"Vessel - test","KeyName":"voyageNumber","label":"Voyage Number"},{"FormName":"Vessel - test","KeyName":"commodityName","label":"Commodity Name"},{"FormName":"Vessel - test","KeyName":"vesselOwnerAddressLine1","label":"Vessel Owner Address-Line 1"}],"placeholder":"","prefix":"","suffix":"","multiple":false,"defaultValue":null,"protected":false,"persistent":true,"clearOnHide":true,"refreshOn":"","redrawOn":"","modalEdit":false,"dataGridLabel":false,"labelPosition":"top","dbIndex":false,"customDefaultValue":"","calculateValue":"","calculateServer":false,"widget":{"type":"input"},"allowCalculateOverride":false,"encrypted":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"id":"ewcelcn"},{"html":"<p>Bill of lading -1st set BL Description</p>","label":"Content","customClass":"","refreshOnChange":false,"hidden":false,"modalEdit":false,"key":"content2","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":"","disabled":false},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":"","disabled":false},"type":"content","input":false,"tableView":false,"validate":{"disabled":false,"required":false,"custom":"","customPrivate":false,"strictDateValidation":false,"multiple":false,"unique":false},"placeholder":"","prefix":"","suffix":"","multiple":false,"defaultValue":null,"protected":false,"unique":false,"persistent":true,"clearOnHide":true,"refreshOn":"","redrawOn":"","dataGridLabel":false,"labelPosition":"top","description":"","errorLabel":"","tooltip":"","hideLabel":false,"tabindex":"","disabled":false,"autofocus":false,"dbIndex":false,"customDefaultValue":"","calculateValue":"","calculateServer":false,"widget":null,"validateOn":"change","allowCalculateOverride":false,"encrypted":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"id":"evthdqn"},{"label":"Bill of Lading","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"autofocus":false,"disabled":false,"tableView":false,"displayAs":"dropdown_single_select","importDataType":"form","formName":"72a65058-5236-4d31-bb0d-3b9ac733a875","fieldName":"textField","valueSelection":"latest","relatedfield":["shipper","consigneeOrderOf","notifyAddress","portOfLoading","portOfDischarging","textField","blIssueDate"],"relatedForm":[],"relatedFormsFields":[],"validate":{"required":false,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"validateOn":"change","errorLabel":"","key":"billOfLading","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"mylookup","input":true,"placeholder":"","prefix":"","suffix":"","multiple":false,"defaultValue":null,"protected":false,"persistent":true,"clearOnHide":true,"refreshOn":"","redrawOn":"","modalEdit":false,"dataGridLabel":false,"labelPosition":"top","dbIndex":false,"customDefaultValue":"","calculateValue":"","calculateServer":false,"widget":{"type":"input"},"allowCalculateOverride":false,"encrypted":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"id":"e93vxn4","selectedFormName":"Bill of Lading (BL)\t","selectedFormId":"72a65058-5236-4d31-bb0d-3b9ac733a875","relatedFieldsLabel":["Shipper","Consignee/Order of","Notify Address","*Port of Loading","*Port of Discharging","BL Number","BL issue date"],"relatedFieldsData1":[{"FormName":"Bill of Lading (BL)\t","KeyName":"shipper","label":"Shipper"},{"FormName":"Bill of Lading (BL)\t","KeyName":"consigneeOrderOf","label":"Consignee/Order of"},{"FormName":"Bill of Lading (BL)\t","KeyName":"notifyAddress","label":"Notify Address"},{"FormName":"Bill of Lading (BL)\t","KeyName":"portOfLoading","label":"*Port of Loading"},{"FormName":"Bill of Lading (BL)\t","KeyName":"portOfDischarging","label":"*Port of Discharging"},{"FormName":"Bill of Lading (BL)\t","KeyName":"textField","label":"BL Number"},{"FormName":"Bill of Lading (BL)\t","KeyName":"blIssueDate","label":"BL issue date"}],"relatedFieldsfinalData":[{"FormName":"Bill of Lading (BL)\t","KeyName":"shipper","label":"Shipper"},{"FormName":"Bill of Lading (BL)\t","KeyName":"consigneeOrderOf","label":"Consignee/Order of"},{"FormName":"Bill of Lading (BL)\t","KeyName":"notifyAddress","label":"Notify Address"},{"FormName":"Bill of Lading (BL)\t","KeyName":"portOfLoading","label":"*Port of Loading"},{"FormName":"Bill of Lading (BL)\t","KeyName":"portOfDischarging","label":"*Port of Discharging"},{"FormName":"Bill of Lading (BL)\t","KeyName":"textField","label":"BL Number"},{"FormName":"Bill of Lading (BL)\t","KeyName":"blIssueDate","label":"BL issue date"}]},{"html":"<p>Switch BL -2nd set BL Description</p>","label":"Content","customClass":"","refreshOnChange":false,"hidden":false,"modalEdit":false,"key":"content3","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":"","disabled":false},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":"","disabled":false},"type":"content","input":false,"tableView":false,"validate":{"disabled":false,"required":false,"custom":"","customPrivate":false,"strictDateValidation":false,"multiple":false,"unique":false},"placeholder":"","prefix":"","suffix":"","multiple":false,"defaultValue":null,"protected":false,"unique":false,"persistent":true,"clearOnHide":true,"refreshOn":"","redrawOn":"","dataGridLabel":false,"labelPosition":"top","description":"","errorLabel":"","tooltip":"","hideLabel":false,"tabindex":"","disabled":false,"autofocus":false,"dbIndex":false,"customDefaultValue":"","calculateValue":"","calculateServer":false,"widget":null,"validateOn":"change","allowCalculateOverride":false,"encrypted":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"id":"eyiwufk"},{"label":"Switch BL Shipper","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":false,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"shipper","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"eirqz34w","defaultValue":""},{"label":"Switch BL Consignee/Order of","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":false,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"switchBlConsigneeOrderOf","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"ens33n","defaultValue":""},{"label":"Switch BL Notify Address","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":false,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"switchBlNotifyAddress","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"e8jdcly","defaultValue":""},{"label":"Switch BL Port of Loading","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":false,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"switchBlPortOfLoading","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"eg5cneh","defaultValue":""},{"label":"Switch BL Port of Discharging","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":false,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"switchBlPortOfDischarging","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"eypgkpe","defaultValue":""},{"label":"Switch BL Number\t","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":false,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"switchBlBlNumber","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"e7akzj","defaultValue":""},{"label":"Switch BL issue date\t","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":false,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"switchBlIssueDate","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"eugrb2k","defaultValue":""},{"label":"Switch BL Quantity (MT)","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":false,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"switchBlQuantityMt","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"eqtttn","defaultValue":""},{"label":"Vessel Contract","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"autofocus":false,"disabled":false,"tableView":false,"displayAs":"dropdown_single_select","importDataType":"form","formName":"52241ba0-77c4-4591-be6a-de2f04eeb1dd","fieldName":"contractNumber","valueSelection":"latest","relatedfield":["chartererName"],"relatedForm":[],"relatedFormsFields":[],"validate":{"required":false,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"validateOn":"change","errorLabel":"","key":"vesselContract","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"mylookup","input":true,"placeholder":"","prefix":"","suffix":"","multiple":false,"defaultValue":null,"protected":false,"persistent":true,"clearOnHide":true,"refreshOn":"","redrawOn":"","modalEdit":false,"dataGridLabel":false,"labelPosition":"top","dbIndex":false,"customDefaultValue":"","calculateValue":"","calculateServer":false,"widget":{"type":"input"},"allowCalculateOverride":false,"encrypted":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"id":"ejy3zpq","selectedFormName":"Vessel - test","selectedFormId":"52241ba0-77c4-4591-be6a-de2f04eeb1dd","relatedFieldsLabel":["Charterer Name"],"relatedFieldsData1":[{"FormName":"Vessel - test","KeyName":"chartererName","label":"Charterer Name"}],"relatedFieldsfinalData":[{"FormName":"Vessel - test","KeyName":"chartererName","label":"Charterer Name"}]},{"label":"Switch BL agent","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":true,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"switchBlAgent","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"etd77s","defaultValue":""},{"label":"Country","labelPosition":"left-left","widget":"choicesjs","placeholder":"","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"uniqueOptions":false,"autofocus":false,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"dataSrc":"url","roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","data":{"values":[{"label":"","value":""}],"resource":"","json":"","url":"backend/TradeManagement/TradeApi/GetFormDropdowns?DropDownType=\"country\"","headers":[{"key":"Content-Type","value":"application/json"},{"key":"Authorization","value":"Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjVFQjQwM0ExNjNFQ0JBNkNFQjVERDM4ODZGOTJDRjVGIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE2NTk5NDQ0MzEsImV4cCI6MTY1OTk1MTYzMSwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eXNlcnZpY2Uuc3RhZ2luZy5ueHVzd29ybGQuY29tIiwiY2xpZW50X2lkIjoiQjUyQ0U0MjQtNUQ0RC00OUQ0LThEMEYtRUVBMzc4ODUzRDM5IDNEMTlFQjRFLTkwMTUtNEU4My05RDFGLTJBMjkzNkUwQzE3MSIsImp0aSI6IjY0MzY5RUM3NDE3NkNGQkI1NDEzQjMzM0I1OTJGNzA4IiwiaWF0IjoxNjU5OTQ0NDMxLCJzY29wZSI6WyIzRDE5RUI0RS05MDE1LTRFODMtOUQxRi0yQTI5MzZFMEMxNzEiXX0.UvBgMhLF6yxdn5Z0uHFDC03xf_xqEt9rrogkoe4pvAyQn3tBzsoXS7qcR56jTXqble7h6kJPYfxSgF1t6LqOfeZFAgOjqY2pP1ECQ8k3UAhowwSAWfp2EjdCWkYSd12ZFfPHlkKnRdO1xpf6-xHKoziYwPhQcG-KP1MlY9WivbLebbVMuJH8gC_0lLoKz1RhQ0g-m2WbsJNbvrfncBqxZgWojBXMlScWS-x9MKA13fz8QZfIUIlUNIl0p5fnrHt8vgM5zLnSYHXb_O7ncoeOD8KC4rLTqq4MCFfuZgWsK671kih4SOojIfo4QqHEFqPqAhquVXEG2h6gVKIzxvu7Hg"}],"custom":""},"dataType":"","idPath":"id","valueProperty":"countryId","template":"<span>{{ item.countryName }}</span>","refreshOn":"","refreshOnBlur":"","clearOnRefresh":false,"searchEnabled":true,"selectThreshold":0.3,"readOnlyValue":false,"customOptions":{},"useExactSearch":false,"persistent":true,"protected":false,"dbIndex":false,"encrypted":false,"clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":true,"onlyAvailableItems":false,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"portofDischargeCountryC1","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"select","indexeddb":{"filter":{}},"selectValues":"data","selectFields":"","searchField":"","minSearch":0,"filter":"","limit":100,"redrawOn":"","input":true,"lazyLoad":false,"disableLimit":false,"prefix":"","suffix":"","dataGridLabel":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"authenticate":false,"ignoreCache":false,"fuseOptions":{"include":"score","threshold":0.3},"id":"epsjugk","defaultValue":"","sort":""}]}' WHERE TemplateTypeName = 'LOI For Switching BLs' AND CompanyId = @CompanyId
UPDATE TradeTemplateType SET FormJson = '{"components":[{"label":"Sales Contract","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"autofocus":false,"disabled":false,"tableView":false,"displayAs":"dropdown_single_select","importDataType":"form","formName":"d6c79b83-6f1d-4366-84fd-c4343a34bed5","fieldName":"contractNumber","valueSelection":"latest","relatedfield":["seller","sellerName","seller1","buyerName","contractNumber","priceAmount"],"relatedForm":[],"relatedFormsFields":[],"validate":{"required":false,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"validateOn":"change","errorLabel":"","key":"salesContract","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"mylookup","input":true,"placeholder":"","prefix":"","suffix":"","multiple":false,"defaultValue":null,"protected":false,"persistent":true,"clearOnHide":true,"refreshOn":"","redrawOn":"","modalEdit":false,"dataGridLabel":false,"labelPosition":"top","dbIndex":false,"customDefaultValue":"","calculateValue":"","calculateServer":false,"widget":{"type":"input"},"allowCalculateOverride":false,"encrypted":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"id":"evwof5h","selectedFormName":"sales contract 20/5","selectedFormId":"d6c79b83-6f1d-4366-84fd-c4343a34bed5","relatedFieldsLabel":["Seller","Name","Buyer","Name","Contract Number","Amount"],"relatedFieldsData1":[{"FormName":"sales contract 20/5","KeyName":"seller","label":"Seller"},{"FormName":"sales contract 20/5","KeyName":"sellerName","label":"Name"},{"FormName":"sales contract 20/5","KeyName":"seller1","label":"Buyer"},{"FormName":"sales contract 20/5","KeyName":"buyerName","label":"Name"},{"FormName":"sales contract 20/5","KeyName":"contractNumber","label":"Contract Number"},{"FormName":"sales contract 20/5","KeyName":"priceAmount","label":"Amount"}],"relatedFieldsfinalData":[{"FormName":"sales contract 20/5","KeyName":"seller","label":"Seller"},{"FormName":"sales contract 20/5","KeyName":"sellerName","label":"Name"},{"FormName":"sales contract 20/5","KeyName":"seller1","label":"Buyer"},{"FormName":"sales contract 20/5","KeyName":"buyerName","label":"Name"},{"FormName":"sales contract 20/5","KeyName":"contractNumber","label":"Contract Number"},{"FormName":"sales contract 20/5","KeyName":"priceAmount","label":"Amount"}]},{"label":"Vessel Contract","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"autofocus":false,"disabled":false,"tableView":false,"displayAs":"dropdown_single_select","importDataType":"form","formName":"52241ba0-77c4-4591-be6a-de2f04eeb1dd","fieldName":"contractNumber","valueSelection":"latest","relatedfield":["vesselName","voyageNumber","commodityName","quantityNumber"],"relatedForm":[],"relatedFormsFields":[],"validate":{"required":false,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"validateOn":"change","errorLabel":"","key":"vesselContract","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"mylookup","input":true,"placeholder":"","prefix":"","suffix":"","multiple":false,"defaultValue":null,"protected":false,"persistent":true,"clearOnHide":true,"refreshOn":"","redrawOn":"","modalEdit":false,"dataGridLabel":false,"labelPosition":"top","dbIndex":false,"customDefaultValue":"","calculateValue":"","calculateServer":false,"widget":{"type":"input"},"allowCalculateOverride":false,"encrypted":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"id":"ep0bd7r","selectedFormName":"Vessel - test","selectedFormId":"52241ba0-77c4-4591-be6a-de2f04eeb1dd","relatedFieldsLabel":["Vessel Name","Voyage Number","Commodity Name","Quantity"],"relatedFieldsData1":[{"FormName":"Vessel - test","KeyName":"vesselName","label":"Vessel Name"},{"FormName":"Vessel - test","KeyName":"voyageNumber","label":"Voyage Number"},{"FormName":"Vessel - test","KeyName":"commodityName","label":"Commodity Name"},{"FormName":"Vessel - test","KeyName":"quantityNumber","label":"Quantity"}],"relatedFieldsfinalData":[{"FormName":"Vessel - test","KeyName":"vesselName","label":"Vessel Name"},{"FormName":"Vessel - test","KeyName":"voyageNumber","label":"Voyage Number"},{"FormName":"Vessel - test","KeyName":"commodityName","label":"Commodity Name"},{"FormName":"Vessel - test","KeyName":"quantityNumber","label":"Quantity"}]},{"label":"Date","labelPosition":"left-left","displayInTimezone":"viewer","useLocaleSettings":false,"allowInput":true,"format":"dd-MMM-yyyy","placeholder":"","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"autofocus":false,"disabled":false,"tableView":false,"modalEdit":false,"shortcutButtons":[],"enableDate":true,"enableMinDateInput":false,"datePicker":{"minDate":null,"maxDate":null,"disable":"","disableFunction":"","disableWeekends":false,"disableWeekdays":false,"showWeeks":true,"startingDay":0,"initDate":"","minMode":"day","maxMode":"year","yearRows":4,"yearColumns":5},"enableMaxDateInput":false,"enableTime":true,"timePicker":{"showMeridian":true,"hourStep":1,"minuteStep":1,"readonlyInput":false,"mousewheel":true,"arrowkeys":true},"multiple":false,"defaultValue":"","defaultDate":"","customOptions":{},"persistent":true,"protected":false,"dbIndex":false,"encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validate":{"required":true,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"validateOn":"change","errorLabel":"","key":"date","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"datetime","timezone":"","input":true,"widget":{"type":"calendar","displayInTimezone":"viewer","locale":"en","useLocaleSettings":false,"allowInput":true,"mode":"single","enableTime":true,"noCalendar":false,"format":"dd-MMM-yyyy","hourIncrement":1,"minuteIncrement":1,"time_24hr":false,"minDate":null,"disabledDates":"","disableWeekends":false,"disableWeekdays":false,"disableFunction":"","maxDate":null},"prefix":"","suffix":"","refreshOn":"","dataGridLabel":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"datepickerMode":"day","id":"esc59ul"},{"label":"Subject","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":true,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"subject","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"ekw4kni","defaultValue":""},{"label":"BL Number","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":true,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"blNumber","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"e0kg98b","defaultValue":""},{"label":"BL Issue Date","labelPosition":"left-left","displayInTimezone":"viewer","useLocaleSettings":false,"allowInput":true,"format":"dd-MMM-yyyy","placeholder":"","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"autofocus":false,"disabled":false,"tableView":false,"modalEdit":false,"shortcutButtons":[],"enableDate":true,"enableMinDateInput":false,"datePicker":{"minDate":null,"maxDate":null,"disable":"","disableFunction":"","disableWeekends":false,"disableWeekdays":false,"showWeeks":true,"startingDay":0,"initDate":"","minMode":"day","maxMode":"year","yearRows":4,"yearColumns":5},"enableMaxDateInput":false,"enableTime":true,"timePicker":{"showMeridian":true,"hourStep":1,"minuteStep":1,"readonlyInput":false,"mousewheel":true,"arrowkeys":true},"multiple":false,"defaultValue":"","defaultDate":"","customOptions":{},"persistent":true,"protected":false,"dbIndex":false,"encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validate":{"required":true,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"validateOn":"change","errorLabel":"","key":"blIssueDate","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"datetime","timezone":"","input":true,"widget":{"type":"calendar","displayInTimezone":"viewer","locale":"en","useLocaleSettings":false,"allowInput":true,"mode":"single","enableTime":true,"noCalendar":false,"format":"dd-MMM-yyyy","hourIncrement":1,"minuteIncrement":1,"time_24hr":false,"minDate":null,"disabledDates":"","disableWeekends":false,"disableWeekdays":false,"disableFunction":"","maxDate":null},"prefix":"","suffix":"","refreshOn":"","dataGridLabel":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"datepickerMode":"day","id":"euvg42o"},{"label":"Port of Loading","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":true,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"portOfLoading","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"enlj5ek","defaultValue":""},{"label":"Port of Discharge","labelPosition":"left-left","placeholder":"","description":"","tooltip":"","prefix":"","suffix":"","widget":{"type":"input"},"inputMask":"","allowMultipleMasks":false,"customClass":"","tabindex":"","autocomplete":"","hidden":false,"hideLabel":false,"showWordCount":false,"showCharCount":false,"mask":false,"autofocus":false,"spellcheck":true,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","persistent":true,"inputFormat":"plain","protected":false,"dbIndex":false,"case":"","encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":true,"pattern":"","customMessage":"","custom":"","customPrivate":false,"json":"","minLength":"","maxLength":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"portOfDischarge","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"textfield","input":true,"refreshOn":"","dataGridLabel":false,"inputType":"text","id":"evviu8h","defaultValue":""},{"label":"Discharge Port Agents","labelPosition":"left-left","widget":"choicesjs","placeholder":"","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"uniqueOptions":false,"autofocus":false,"disabled":false,"tableView":true,"modalEdit":false,"multiple":false,"dataSrc":"url","roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"dataSource":"","data":{"values":[{"label":"","value":""}],"resource":"","json":"","url":"backend/TradeManagement/TradeApi/GetFormDropdowns?DropDownType=portagent","headers":[{"key":"Authorization","value":"Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjVFQjQwM0ExNjNFQ0JBNkNFQjVERDM4ODZGOTJDRjVGIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE2NTk5NDQ0MzEsImV4cCI6MTY1OTk1MTYzMSwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eXNlcnZpY2Uuc3RhZ2luZy5ueHVzd29ybGQuY29tIiwiY2xpZW50X2lkIjoiQjUyQ0U0MjQtNUQ0RC00OUQ0LThEMEYtRUVBMzc4ODUzRDM5IDNEMTlFQjRFLTkwMTUtNEU4My05RDFGLTJBMjkzNkUwQzE3MSIsImp0aSI6IjY0MzY5RUM3NDE3NkNGQkI1NDEzQjMzM0I1OTJGNzA4IiwiaWF0IjoxNjU5OTQ0NDMxLCJzY29wZSI6WyIzRDE5RUI0RS05MDE1LTRFODMtOUQxRi0yQTI5MzZFMEMxNzEiXX0.UvBgMhLF6yxdn5Z0uHFDC03xf_xqEt9rrogkoe4pvAyQn3tBzsoXS7qcR56jTXqble7h6kJPYfxSgF1t6LqOfeZFAgOjqY2pP1ECQ8k3UAhowwSAWfp2EjdCWkYSd12ZFfPHlkKnRdO1xpf6-xHKoziYwPhQcG-KP1MlY9WivbLebbVMuJH8gC_0lLoKz1RhQ0g-m2WbsJNbvrfncBqxZgWojBXMlScWS-x9MKA13fz8QZfIUIlUNIl0p5fnrHt8vgM5zLnSYHXb_O7ncoeOD8KC4rLTqq4MCFfuZgWsK671kih4SOojIfo4QqHEFqPqAhquVXEG2h6gVKIzxvu7Hg"}],"custom":""},"dataType":"","idPath":"id","valueProperty":"clientId","template":"<span>{{ item.fullName }}</span>","refreshOn":"","refreshOnBlur":"","clearOnRefresh":false,"searchEnabled":true,"selectThreshold":0.3,"readOnlyValue":false,"customOptions":{},"useExactSearch":false,"persistent":true,"protected":false,"dbIndex":false,"encrypted":false,"clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validateOn":"change","validate":{"required":true,"onlyAvailableItems":false,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"unique":false,"errorLabel":"","key":"dischargePortAgents","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"select","indexeddb":{"filter":{}},"selectValues":"data","selectFields":"","searchField":"","minSearch":0,"filter":"","limit":100,"redrawOn":"","input":true,"disableLimit":false,"prefix":"","suffix":"","dataGridLabel":false,"showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"lazyLoad":true,"authenticate":false,"ignoreCache":false,"fuseOptions":{"include":"score","threshold":0.3},"id":"enu5n7","sort":"","defaultValue":{}},{"label":"Seller Signature","footer":"Sign above","labelPosition":"left-left","width":"100%","height":"150px","backgroundColor":"rgb(245,245,235)","penColor":"black","description":"","tooltip":"","customClass":"","tabindex":"","hidden":false,"hideLabel":false,"disabled":false,"tableView":false,"modalEdit":false,"roleView":[],"userView":[],"roleEdit":[],"userEdit":[],"persistent":true,"protected":false,"encrypted":false,"redrawOn":"","clearOnHide":true,"customDefaultValue":"","calculateValue":"","calculateServer":false,"allowCalculateOverride":false,"validate":{"required":true,"customMessage":"","custom":"","customPrivate":false,"json":"","strictDateValidation":false,"multiple":false,"unique":false},"errorLabel":"","key":"sellerSignature","tags":[],"properties":{},"conditional":{"show":null,"when":null,"eq":"","json":""},"customConditional":"","logic":[],"attributes":{},"overlay":{"style":"","page":"","left":"","top":"","width":"","height":""},"type":"signature","input":true,"placeholder":"","prefix":"","suffix":"","multiple":false,"defaultValue":null,"unique":false,"refreshOn":"","dataGridLabel":false,"autofocus":false,"dbIndex":false,"widget":{"type":"input"},"validateOn":"change","showCharCount":false,"showWordCount":false,"allowMultipleMasks":false,"minWidth":"0.5","maxWidth":"2.5","id":"eldfgzm"}]}' WHERE TemplateTypeName = 'Shipment Tender' AND CompanyId = CompanyId

END
GO