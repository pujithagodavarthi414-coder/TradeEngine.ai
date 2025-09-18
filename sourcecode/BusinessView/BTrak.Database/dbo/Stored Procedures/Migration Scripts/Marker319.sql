CREATE PROCEDURE [dbo].[Marker319]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].InterviewType AS Target 
 		USING (VALUES 
		(NEWID(),'Level 1' ,0 , 0, '#5115e2' ,@CompanyId, @UserId,GETDATE())
       ,(NEWID(),'Level 5' ,0 , 0, '#034946' ,@CompanyId, @UserId,GETDATE())
       ,(NEWID(),'Level 2' ,0 , 0, '#439315' ,@CompanyId, @UserId,GETDATE())
       ,(NEWID(),'Level 4' ,1 , 0, '#f1515f' ,@CompanyId, @UserId,GETDATE())
       ,(NEWID(),'Level 3' ,0 , 1, '#e215a9' ,@CompanyId, @UserId,GETDATE())
		)		
		AS Source ([Id], InterviewTypeName, IsVideoCalling,IsPhoneCalling,[Color],CompanyId,  [CreatedByUserId],[CreatedDateTime])
		ON Target.InterviewTypeName = Source.InterviewTypeName AND Target.CompanyId = Source.CompanyId
		WHEN MATCHED THEN 
		UPDATE SET
				   InterviewTypeName = Source.InterviewTypeName,
				   IsVideoCalling = Source.IsVideoCalling
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], InterviewTypeName, IsVideoCalling,IsPhoneCalling,[Color],CompanyId,  [CreatedByUserId],[CreatedDateTime])
		VALUES ([Id], InterviewTypeName, IsVideoCalling,IsPhoneCalling,[Color],CompanyId,  [CreatedByUserId],[CreatedDateTime]);	

	   MERGE INTO [dbo].InterviewProcess AS Target 
		USING (VALUES 
		(NEWID(),'Process 1'  ,@CompanyId, @UserId,GETDATE())
		)		
		AS Source ([Id], InterviewProcessName,CompanyId,  [CreatedByUserId],[CreatedDateTime])
		ON Target.InterviewProcessName = Source.InterviewProcessName AND Target.CompanyId = Source.CompanyId
		WHEN MATCHED THEN 
		UPDATE SET
				   InterviewProcessName = Source.InterviewProcessName
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], InterviewProcessName,CompanyId,  [CreatedByUserId],[CreatedDateTime])
		VALUES ([Id], InterviewProcessName,CompanyId,  [CreatedByUserId],[CreatedDateTime]);	


       MERGE INTO [dbo].InterviewProcessTypeConfiguration AS Target 
		USING (VALUES 
		(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 1' AND CompanyId = @CompanyId),  (SELECT Id FROM InterviewProcess WHERE InterviewProcessName = 'Process 1' and CompanyId = @CompanyId),@UserId,GETDATE())
       ,(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 5' AND CompanyId = @CompanyId),  (SELECT Id FROM InterviewProcess WHERE InterviewProcessName = 'Process 1' and CompanyId = @CompanyId),@UserId,GETDATE())
       ,(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 2' AND CompanyId = @CompanyId),  (SELECT Id FROM InterviewProcess WHERE InterviewProcessName = 'Process 1' and CompanyId = @CompanyId),@UserId,GETDATE())
       ,(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 4' AND CompanyId = @CompanyId),  (SELECT Id FROM InterviewProcess WHERE InterviewProcessName = 'Process 1' and CompanyId = @CompanyId),@UserId,GETDATE())
       ,(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 3' AND CompanyId = @CompanyId),  (SELECT Id FROM InterviewProcess WHERE InterviewProcessName = 'Process 1' and CompanyId = @CompanyId),@UserId,GETDATE())
		)		
		AS Source ([Id], InterviewTypeId, InterviewProcessId,  [CreatedByUserId],[CreatedDateTime])
		ON Target.InterviewTypeId = Source.InterviewTypeId AND Target.InterviewProcessId = Source.InterviewProcessId
		WHEN MATCHED THEN 
		UPDATE SET
				   InterviewTypeId = Source.InterviewTypeId,
				   InterviewProcessId = Source.InterviewProcessId
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], InterviewTypeId, InterviewProcessId,  [CreatedByUserId],[CreatedDateTime])
		VALUES ([Id], InterviewTypeId, InterviewProcessId,  [CreatedByUserId],[CreatedDateTime]);	

	MERGE INTO [dbo].[InterviewTypeRoleCofiguration] AS Target 
		USING (VALUES 
		(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 1' AND CompanyId = @CompanyId),  (SELECT TOP 1 Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId),@UserId,GETDATE())
       ,(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 5' AND CompanyId = @CompanyId),  (SELECT TOP 1 Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId),@UserId,GETDATE())
       ,(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 2' AND CompanyId = @CompanyId),  (SELECT TOP 1 Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId),@UserId,GETDATE())
       ,(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 4' AND CompanyId = @CompanyId),  (SELECT TOP 1 Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId),@UserId,GETDATE())
       ,(NEWID(),(SELECT Id FROM InterviewType WHERE InterviewTypeName = 'Level 3' AND CompanyId = @CompanyId),  (SELECT TOP 1 Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId),@UserId,GETDATE())
		)		
		AS Source ([Id], InterviewTypeId, [RoleId],  [CreatedByUserId],[CreatedDateTime])
		ON Target.InterviewTypeId = Source.InterviewTypeId AND Target.[RoleId] = Source.[RoleId]
		WHEN MATCHED THEN 
		UPDATE SET
				   InterviewTypeId = Source.InterviewTypeId,
				   [RoleId] = Source.[RoleId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], InterviewTypeId, [RoleId],  [CreatedByUserId],[CreatedDateTime])
		VALUES ([Id], InterviewTypeId, [RoleId],  [CreatedByUserId],[CreatedDateTime]);	

	UPDATE [dbo].[CrmExternalServicesProperties] SET [Value] = 'wM3TtmlpU0JXd73iCSToEzZJTZtqhnAl' WHERE [Name] = 'APISecret' AND CompanyId = @CompanyId
	UPDATE [dbo].[CrmExternalServicesProperties] SET [Value] = 'SK74d48ac8d784865d218e7fea776dd08f' WHERE [Name] = 'APIKey' AND CompanyId = @CompanyId
	UPDATE [dbo].[CrmExternalServicesProperties] SET [Value] = 'AC3c15d0c7705b4cc6d3d9c556541f9aec' WHERE [Name] = 'AccountSID' AND CompanyId = @CompanyId
	UPDATE [dbo].[CrmExternalServicesProperties] SET [Value] = '778f94fdace4430ac92da79dc17620e8' WHERE [Name] = 'AuthToken' AND CompanyId = @CompanyId
	UPDATE [dbo].[CrmExternalServicesProperties] SET [Value] = 'AP6c5adbdf901dda18206668a3482003f7' WHERE [Name] = 'AppSID' AND CompanyId = @CompanyId


	UPDATE [dbo].[GenericForm] SET [FormJson]='{
	"components": [{
		"label": "Columns",
		"columns": [{
			"components": [{
				"label": "First name",
				"placeholder": "First name",
				"allowMultipleMasks": false,
				"showWordCount": false,
				"showCharCount": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "textfield",
				"input": true,
				"key": "FirstName",
				"defaultValue": "",
				"validate": {
					"required": true,
					"customMessage": "",
					"json": "",
					"minLength": 1
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"inputFormat": "plain",
				"encrypted": false,
				"properties": {},
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"widget": {
					"type": ""
				},
				"tags": [],
				"reorder": false
			}, {
				"label": "Email",
				"placeholder": "Email",
				"tableView": true,
				"alwaysEnabled": false,
				"type": "email",
				"input": true,
				"key": "Email",
				"defaultValue": "",
				"validate": {
					"required": true,
					"customMessage": "",
					"json": ""
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"encrypted": false,
				"properties": {},
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"tags": [],
				"reorder": false
			}, {
				"label": "Phone number",
				"placeholder": "Phone number",
				"allowMultipleMasks": false,
				"showWordCount": false,
				"showCharCount": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "phoneNumber",
				"input": true,
				"key": "PhoneNumber",
				"defaultValue": "",
				"validate": {
					"customMessage": "",
					"json": "",
					"required": true
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"inputFormat": "plain",
				"encrypted": false,
				"properties": {},
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"tags": [],
				"reorder": false
			}, {
				"label": "Current salary",
				"placeholder": "Current salary",
				"mask": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "number",
				"input": true,
				"key": "CurrentSalary",
				"validate": {
					"min": 0,
					"customMessage": "",
					"json": ""
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"delimiter": false,
				"requireDecimal": false,
				"encrypted": false,
				"properties": {},
				"tags": [],
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"reorder": false
			}, {
				"label": "Current designation",
				"placeholder": "Current designation",
				"mask": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "select",
				"input": true,
				"key": "CurrentDesignation",
				"defaultValue": "",
				"validate": {
					"required": true,
					"customMessage": "",
					"json": "",
					"select": false
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"data": {
					"values": [{
						"label": "",
						"value": ""
					}]
				},
				"valueProperty": "value",
				"selectThreshold": 0.3,
				"encrypted": false,
				"properties": {},
				"tags": [],
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"reorder": false,
				"lazyLoad": false,
				"selectValues": "",
				"disableLimit": false,
				"sort": "",
				"reference": false
			}, {
				"label": "SkypeId",
				"placeholder": "SkypeId",
				"allowMultipleMasks": false,
				"showWordCount": false,
				"showCharCount": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "textfield",
				"input": true,
				"key": "SkypeId",
				"defaultValue": "",
				"validate": {
					"customMessage": "",
					"json": ""
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"widget": {
					"type": ""
				},
				"properties": {},
				"tags": [],
				"reorder": false,
				"inputFormat": "plain",
				"encrypted": false,
				"customConditional": "",
				"logic": [],
				"attributes": {}
			}],
			"width": 6,
			"offset": 0,
			"push": 0,
			"pull": 0,
			"type": "column",
			"input": false,
			"hideOnChildrenHidden": false,
			"key": "column",
			"tableView": true,
			"label": "Column"
		}, {
			"components": [{
				"label": "Last name",
				"placeholder": "Last name",
				"allowMultipleMasks": false,
				"showWordCount": false,
				"showCharCount": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "textfield",
				"input": true,
				"key": "LastName",
				"defaultValue": "",
				"validate": {
					"required": true,
					"customMessage": "",
					"json": "",
					"minLength": 1
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"inputFormat": "plain",
				"encrypted": false,
				"properties": {},
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"widget": {
					"type": ""
				},
				"tags": [],
				"reorder": false
			}, {
				"label": "Secondary email",
				"placeholder": "Secondary email",
				"tableView": true,
				"alwaysEnabled": false,
				"type": "email",
				"input": true,
				"key": "SecondaryEmail",
				"defaultValue": "",
				"validate": {
					"customMessage": "",
					"json": ""
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"encrypted": false,
				"properties": {},
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"tags": [],
				"reorder": false
			}, {
				"label": "Father name",
				"placeholder": "Father name",
				"allowMultipleMasks": false,
				"showWordCount": false,
				"showCharCount": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "textfield",
				"input": true,
				"key": "FatherName",
				"defaultValue": "",
				"validate": {
					"customMessage": "",
					"json": ""
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"properties": {},
				"tags": [],
				"widget": {
					"type": ""
				},
				"inputFormat": "plain",
				"encrypted": false,
				"reorder": false,
				"customConditional": "",
				"logic": [],
				"attributes": {}
			}, {
				"label": "Experience in years",
				"placeholder": "Experience in years",
				"mask": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "number",
				"input": true,
				"key": "ExperienceInYears",
				"validate": {
					"customMessage": "",
					"json": "",
					"min": 0
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"properties": {},
				"tags": [],
				"delimiter": false,
				"requireDecimal": false,
				"encrypted": false,
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"reorder": false
			}, {
				"label": "Expected salary",
				"placeholder": "Expected salary",
				"mask": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "number",
				"input": true,
				"key": "ExpectedSalary",
				"validate": {
					"min": 0,
					"customMessage": "",
					"json": ""
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"delimiter": false,
				"requireDecimal": false,
				"encrypted": false,
				"properties": {},
				"tags": [],
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"reorder": false
			}, {
				"label": "Reference employeeid",
				"placeholder": "Reference employeeid",
				"allowMultipleMasks": false,
				"showWordCount": false,
				"showCharCount": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "textfield",
				"input": true,
				"key": "ReferenceEmployeeId",
				"defaultValue": "",
				"validate": {
					"customMessage": "",
					"json": ""
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"inputFormat": "plain",
				"encrypted": false,
				"properties": {},
				"tags": [],
				"widget": {
					"type": ""
				},
				"reorder": false,
				"customConditional": "",
				"logic": [],
				"attributes": {}
			}],
			"width": 6,
			"offset": 0,
			"push": 0,
			"pull": 0,
			"type": "column",
			"input": false,
			"hideOnChildrenHidden": false,
			"key": "column",
			"tableView": true,
			"label": "Column"
		}],
		"mask": false,
		"tableView": false,
		"alwaysEnabled": false,
		"type": "columns",
		"input": false,
		"key": "columns2",
		"conditional": {
			"show": "",
			"when": "",
			"json": ""
		},
		"reorder": false,
		"properties": {},
		"customConditional": "",
		"logic": [],
		"attributes": {}
	}, {
		"label": "Columns",
		"columns": [{
			"components": [{
				"label": "Address street1",
				"placeholder": "Address street1",
				"allowMultipleMasks": false,
				"showWordCount": false,
				"showCharCount": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "textfield",
				"input": true,
				"key": "AddressStreet1",
				"defaultValue": "",
				"validate": {
					"customMessage": "",
					"json": ""
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"inputFormat": "plain",
				"encrypted": false,
				"properties": {},
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"widget": {
					"type": ""
				},
				"tags": [],
				"reorder": false
			}, {
				"label": "State",
				"placeholder": "State",
				"mask": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "select",
				"input": true,
				"key": "State",
				"defaultValue": "",
				"validate": {
					"required": true,
					"customMessage": "",
					"json": "",
					"select": false
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"data": {
					"values": [{
						"label": "",
						"value": ""
					}]
				},
				"valueProperty": "value",
				"selectThreshold": 0.3,
				"encrypted": false,
				"properties": {},
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"tags": [],
				"reorder": false,
				"lazyLoad": false,
				"selectValues": "",
				"disableLimit": false,
				"sort": "",
				"reference": false
			}, {
				"label": "Zip code",
				"placeholder": "Zip code",
				"allowMultipleMasks": false,
				"showWordCount": false,
				"showCharCount": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "textfield",
				"input": true,
				"key": "ZipCode",
				"defaultValue": "",
				"validate": {
					"pattern": "[0-9]+",
					"customMessage": "",
					"json": "",
					"maxLength": 20,
					"required": true
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"inputFormat": "plain",
				"encrypted": false,
				"properties": {},
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"tags": [],
				"widget": {
					"type": ""
				},
				"reorder": false
			}],
			"width": 6,
			"offset": 0,
			"push": 0,
			"pull": 0,
			"type": "column",
			"input": false,
			"hideOnChildrenHidden": false,
			"key": "column",
			"tableView": true,
			"label": "Column"
		}, {
			"components": [{
				"label": "Address street2",
				"placeholder": "Address street2",
				"allowMultipleMasks": false,
				"showWordCount": false,
				"showCharCount": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "textfield",
				"input": true,
				"key": "AddressStreet2",
				"defaultValue": "",
				"validate": {
					"customMessage": "",
					"json": ""
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"widget": {
					"type": ""
				},
				"properties": {},
				"tags": [],
				"reorder": false,
				"inputFormat": "plain",
				"encrypted": false,
				"customConditional": "",
				"logic": [],
				"attributes": {}
			}, {
				"label": "Country",
				"placeholder": "Country",
				"mask": false,
				"tableView": true,
				"alwaysEnabled": false,
				"type": "select",
				"input": true,
				"key": "Country",
				"defaultValue": "",
				"validate": {
					"required": true,
					"customMessage": "",
					"json": "",
					"select": false
				},
				"conditional": {
					"show": "",
					"when": "",
					"json": ""
				},
				"data": {
					"values": [{
						"label": "",
						"value": ""
					}]
				},
				"valueProperty": "value",
				"selectThreshold": 0.3,
				"encrypted": false,
				"properties": {},
				"customConditional": "",
				"logic": [],
				"attributes": {},
				"tags": [],
				"reorder": false,
				"lazyLoad": false,
				"selectValues": "",
				"disableLimit": false,
				"sort": "",
				"reference": false
			}],
			"width": 6,
			"offset": 0,
			"push": 0,
			"pull": 0,
			"type": "column",
			"input": false,
			"hideOnChildrenHidden": false,
			"key": "column",
			"tableView": true,
			"label": "Column"
		}],
		"mask": false,
		"tableView": false,
		"alwaysEnabled": false,
		"type": "columns",
		"input": false,
		"key": "columns3",
		"conditional": {
			"show": "",
			"when": "",
			"json": ""
		},
		"reorder": false,
		"properties": {},
		"customConditional": "",
		"logic": [],
		"attributes": {}
	}, {
		"label": "Education details",
		"reorder": false,
		"mask": false,
		"tableView": true,
		"alwaysEnabled": false,
		"type": "editgrid",
		"input": true,
		"key": "EducationDetails",
		"validate": {
			"customMessage": "",
			"json": "",
			"required": true
		},
		"conditional": {
			"show": "",
			"when": "",
			"json": ""
		},
		"components": [{
			"label": "Institute",
			"placeholder": "Institute",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "Institute",
			"defaultValue": "",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": "",
				"minLength": 1
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"tags": [],
			"widget": {
				"type": ""
			},
			"reorder": false
		}, {
			"label": "Department",
			"placeholder": "Department",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "Department",
			"defaultValue": "",
			"validate": {
				"customMessage": "",
				"json": "",
				"required": true,
				"minLength": 1
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"widget": {
				"type": ""
			},
			"tags": [],
			"reorder": false
		}, {
			"label": "Name of degree",
			"placeholder": "Name of degree",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "NameOfDegree",
			"defaultValue": "",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": "",
				"minLength": 1
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"tags": [],
			"unique": true,
			"widget": {
				"type": ""
			},
			"reorder": false
		}, {
			"label": "From date",
			"hideInputLabels": false,
			"inputsLabelPosition": "top",
			"fields": {
				"day": {
					"placeholder": "Day",
					"hide": false,
					"type": "number",
					"required": true
				},
				"month": {
					"placeholder": "Month",
					"hide": false,
					"type": "select",
					"required": true
				},
				"year": {
					"placeholder": "Year",
					"hide": false,
					"type": "number",
					"required": true
				}
			},
			"useLocaleSettings": true,
			"mask": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "day",
			"input": true,
			"key": "DateFrom",
			"validate": {
				"customMessage": "",
				"json": ""
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"encrypted": false,
			"maxDate": "",
			"minDate": "",
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"tags": [],
			"reorder": false
		}, {
			"label": "To date",
			"hideInputLabels": false,
			"inputsLabelPosition": "top",
			"fields": {
				"day": {
					"placeholder": "Day",
					"hide": false,
					"type": "number"
				},
				"month": {
					"placeholder": "Month",
					"hide": false,
					"type": "select"
				},
				"year": {
					"placeholder": "Year",
					"hide": false,
					"type": "number"
				}
			},
			"useLocaleSettings": false,
			"mask": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "day",
			"input": true,
			"key": "DateTo",
			"validate": {
				"customMessage": "",
				"json": ""
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"encrypted": false,
			"maxDate": "",
			"minDate": "",
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"tags": [],
			"reorder": false
		}],
		"rowClass": "",
		"addAnother": "",
		"modal": false,
		"saveRow": "",
		"encrypted": false,
		"properties": {},
		"customConditional": "",
		"logic": [],
		"attributes": {},
		"tags": []
	}, {
		"label": "Experience",
		"placeholder": "Experience",
		"reorder": false,
		"mask": false,
		"tableView": true,
		"alwaysEnabled": false,
		"type": "editgrid",
		"input": true,
		"key": "Experience",
		"validate": {
			"customMessage": "",
			"json": ""
		},
		"conditional": {
			"show": "",
			"when": "",
			"json": ""
		},
		"components": [{
			"label": "Occupation title",
			"placeholder": "Occupation title",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "OccupationTitle",
			"defaultValue": "",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": "",
				"minLength": 1
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"widget": {
				"type": ""
			},
			"tags": [],
			"reorder": false
		}, {
			"label": "Company name",
			"placeholder": "Company name",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "CompanyName",
			"defaultValue": "",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": "",
				"minLength": 1
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"widget": {
				"type": ""
			},
			"tags": [],
			"reorder": false
		}, {
			"label": "Company type",
			"placeholder": "Company type",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "CompanyType",
			"defaultValue": "",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": "",
				"minLength": 1
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"widget": {
				"type": ""
			},
			"tags": [],
			"reorder": false
		}, {
			"label": "Description",
			"placeholder": "Description",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "Description",
			"defaultValue": "",
			"validate": {
				"customMessage": "",
				"json": ""
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"widget": {
				"type": ""
			},
			"tags": [],
			"reorder": false
		}, {
			"label": "Date from",
			"hideInputLabels": false,
			"inputsLabelPosition": "top",
			"fields": {
				"day": {
					"placeholder": "Day",
					"hide": false,
					"type": "number",
					"required": true
				},
				"month": {
					"placeholder": "Month",
					"hide": false,
					"type": "select",
					"required": true
				},
				"year": {
					"placeholder": "Year",
					"hide": false,
					"type": "number",
					"required": true
				}
			},
			"useLocaleSettings": true,
			"mask": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "day",
			"input": true,
			"key": "DateFrom",
			"validate": {
				"customMessage": "",
				"json": ""
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"maxDate": "",
			"minDate": "",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"tags": [],
			"reorder": false
		}, {
			"label": "Date to",
			"hideInputLabels": false,
			"inputsLabelPosition": "top",
			"fields": {
				"day": {
					"placeholder": "Day",
					"hide": false,
					"type": "number",
					"required": true
				},
				"month": {
					"placeholder": "Month",
					"hide": false,
					"type": "select",
					"required": true
				},
				"year": {
					"placeholder": "Year",
					"hide": false,
					"type": "number",
					"required": true
				}
			},
			"useLocaleSettings": true,
			"mask": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "day",
			"input": true,
			"key": "DateTo",
			"validate": {
				"customMessage": "",
				"json": ""
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"encrypted": false,
			"maxDate": "",
			"minDate": "",
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"tags": [],
			"reorder": false
		}, {
			"label": "Location",
			"placeholder": "Location",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "Location",
			"defaultValue": "",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": ""
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"widget": {
				"type": ""
			},
			"tags": [],
			"reorder": false
		}, {
			"label": "Salary",
			"placeholder": "Salary",
			"mask": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "number",
			"input": true,
			"key": "Salary",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": "",
				"min": 0
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"delimiter": false,
			"requireDecimal": false,
			"encrypted": false,
			"properties": {},
			"tags": [],
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"reorder": false
		}],
		"rowClass": "",
		"addAnother": "",
		"modal": false,
		"saveRow": "",
		"encrypted": false,
		"properties": {},
		"customConditional": "",
		"logic": [],
		"attributes": {},
		"tags": [],
		"templates": {
			"row": "<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-1\">\n        {{ getView(component, row[component.key]) }}\n      </div>\n    {% } %}\n  {% }) %}\n  {% if (!instance.options.readOnly) { %}\n    <div class=\"col\">\n      <div class=\"btn-group pull-right\">\n        <button class=\"btn btn-default btn-light btn-sm editRow\"><i class=\"{{ iconClass(''edit'') }}\"></i></button>\n        <button class=\"btn btn-danger btn-sm removeRow\"><i class=\"{{ iconClass(''trash'') }}\"></i></button>\n      </div>\n    </div>\n  {% } %}\n</div>",
			"header": "<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-1\">{{ component.label }}</div>\n    {% } %}\n  {% }) %}\n</div>"
		}
	}, {
		"label": "Skills",
		"placeholder": "Skills",
		"reorder": false,
		"mask": false,
		"tableView": true,
		"alwaysEnabled": false,
		"type": "editgrid",
		"input": true,
		"key": "Skills",
		"validate": {
			"customMessage": "",
			"json": ""
		},
		"conditional": {
			"show": "",
			"when": "",
			"json": ""
		},
		"components": [{
			"label": "Skill name",
			"placeholder": "Skill name",
			"mask": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "select",
			"input": true,
			"key": "SkillName",
			"defaultValue": "",
			"validate": {
				"customMessage": "",
				"json": "",
				"required": true,
				"select": false
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"data": {
				"values": [{
					"label": "",
					"value": ""
				}]
			},
			"valueProperty": "value",
			"selectThreshold": 0.3,
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"tags": [],
			"reorder": false,
			"lazyLoad": false,
			"selectValues": "",
			"disableLimit": false,
			"sort": "",
			"reference": false
		}, {
			"label": "Experience",
			"placeholder": "Experience",
			"mask": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "number",
			"input": true,
			"key": "Experience",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": "",
				"min": 0
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"delimiter": false,
			"requireDecimal": false,
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"tags": [],
			"reorder": false
		}],
		"rowClass": "",
		"addAnother": "",
		"modal": false,
		"saveRow": "",
		"encrypted": false,
		"properties": {},
		"customConditional": "",
		"logic": [],
		"attributes": {},
		"tags": [],
		"templates": {
			"row": "<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-2\">\n        {{ getView(component, row[component.key]) }}\n      </div>\n    {% } %}\n  {% }) %}\n  {% if (!instance.options.readOnly) { %}\n    <div class=\"col\">\n      <div class=\"btn-group pull-right\">\n        <button class=\"btn btn-default btn-light btn-sm editRow\"><i class=\"{{ iconClass(''edit'') }}\"></i></button>\n        <button class=\"btn btn-danger btn-sm removeRow\"><i class=\"{{ iconClass(''trash'') }}\"></i></button>\n      </div>\n    </div>\n  {% } %}\n</div>"
		}
	}, {
		"label": "Documents",
		"placeholder": "Documents",
		"reorder": false,
		"mask": false,
		"tableView": true,
		"alwaysEnabled": false,
		"type": "editgrid",
		"input": true,
		"key": "Documents",
		"validate": {
			"customMessage": "",
			"json": "",
			"required": true
		},
		"conditional": {
			"show": "",
			"when": "",
			"json": ""
		},
		"components": [{
			"label": "Document name",
			"placeholder": "Document name",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "DocumentName",
			"defaultValue": "",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": ""
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"tags": [],
			"unique": true,
			"widget": {
				"type": ""
			},
			"reorder": false
		}, {
			"label": "Description",
			"placeholder": "Description",
			"allowMultipleMasks": false,
			"showWordCount": false,
			"showCharCount": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "textfield",
			"input": true,
			"key": "Description",
			"defaultValue": "",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": "",
				"minLength": 1
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"inputFormat": "plain",
			"encrypted": false,
			"properties": {},
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"widget": {
				"type": ""
			},
			"tags": [],
			"reorder": false
		}, {
			"label": "Document type",
			"placeholder": "Document type",
			"mask": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "select",
			"input": true,
			"key": "DocumentType",
			"defaultValue": "",
			"validate": {
				"required": true,
				"customMessage": "",
				"json": "",
				"select": false
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"data": {
				"values": [{
					"label": "",
					"value": ""
				}]
			},
			"valueProperty": "value",
			"selectThreshold": 0.3,
			"encrypted": false,
			"properties": {},
			"tags": [],
			"customConditional": "",
			"logic": [],
			"attributes": {},
			"reorder": false,
			"lazyLoad": false,
			"selectValues": "",
			"disableLimit": false,
			"sort": "",
			"reference": false
		}, {
			"label": "Upload document",
			"placeholder": "Upload document",
			"multiple": true,
			"reorder": false,
			"mask": false,
			"tableView": true,
			"alwaysEnabled": false,
			"type": "file",
			"input": true,
			"key": "UploadDocument",
			"defaultValue": [],
			"validate": {
				"customMessage": "",
				"json": "",
				"required": true
			},
			"conditional": {
				"show": "",
				"when": "",
				"json": ""
			},
			"storage": "url",
			"dir": "",
			"fileNameTemplate": "",
			"webcam": false,
			"fileTypes": [{
				"label": "",
				"value": ""
			}],
			"encrypted": false,
			"customConditional": "",
			"properties": {},
			"logic": [],
			"attributes": {},
			"tags": [],
			"url": "https://btrak643-development.snovasys.com/backend/File/FileApi/UploadFileForRecruitment?moduleTypeId=15",
			"options": "",
			"webcamSize": ""
		}],
		"rowClass": "",
		"addAnother": "",
		"modal": false,
		"saveRow": "",
		"encrypted": false,
		"properties": {},
		"customConditional": "",
		"logic": [],
		"attributes": {},
		"tags": [],
		"templates": {
			"row": "<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-2\">\n        {{ getView(component, row[component.key]) }}\n      </div>\n    {% } %}\n  {% }) %}\n  {% if (!instance.options.readOnly) { %}\n    <div class=\"col\">\n      <div class=\"btn-group pull-right\">\n        <button class=\"btn btn-default btn-light btn-sm editRow\"><i class=\"{{ iconClass(''edit'') }}\"></i></button>\n        <button class=\"btn btn-danger btn-sm removeRow\"><i class=\"{{ iconClass(''trash'') }}\"></i></button>\n      </div>\n    </div>\n  {% } %}\n</div>"
		}
	}, {
		"label": "Upload resume",
		"placeholder": "Upload Resume",
		"multiple": true,
		"mask": false,
		"tableView": true,
		"alwaysEnabled": false,
		"type": "file",
		"input": true,
		"key": "UploadResume",
		"defaultValue": [],
		"validate": {
			"required": true,
			"customMessage": "",
			"json": ""
		},
		"conditional": {
			"show": "",
			"when": "",
			"json": ""
		},
		"storage": "url",
		"dir": "",
		"fileNameTemplate": "",
		"webcam": false,
		"fileTypes": [{
			"label": "",
			"value": ""
		}],
		"url": "https://btrak643-development.snovasys.com/backend/File/FileApi/UploadFileForRecruitment?moduleTypeId=15",
		"options": "",
		"encrypted": false,
		"properties": {},
		"webcamSize": "",
		"customConditional": "",
		"logic": [],
		"attributes": {},
		"reorder": false
	}, {
		"label": "Submit",
		"state": "",
		"theme": "primary",
		"shortcut": "",
		"disableOnInvalid": true,
		"mask": false,
		"tableView": true,
		"alwaysEnabled": false,
		"type": "button",
		"key": "submit",
		"input": true,
		"defaultValue": false,
		"validate": {
			"customMessage": "",
			"json": ""
		},
		"conditional": {
			"show": "",
			"when": "",
			"json": ""
		},
		"encrypted": false,
		"properties": {},
		"customConditional": "",
		"logic": [],
		"attributes": {},
		"showValidations": false,
		"event": "",
		"url": "",
		"custom": "",
		"reorder": false
	}]
}'

    FROM [GenericForm] AS G
		JOIN [FormType] AS F ON F.Id = G.FormTypeId AND F.CompanyId = @CompanyId
	WHERE [FormName] = 'Candidate registration form' AND F.CompanyId = @CompanyId

		MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                 (NEWID(),'InterviewScheduleConfirmedTemplate',
        '<!doctype html>  
		<html lang="en">    
		<head>     
		<meta charset="utf-8">      
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">      
		<meta name="x-apple-disable-message-reformatting">      
		<meta http-equiv="X-UA-Compatible" content="IE=edge">     
		<title>Service Confirmation</title>     
		<style type="text/css">        a { text-decoration: none; outline: none; }       
		@media (max-width: 649px) {          .o_col-full { max-width: 100% !important; }         
		.o_col-half { max-width: 50% !important; }   
		.o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important overflow: visible !important; width: auto !important; visibility: visible !important; }          
		.o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; 
		line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }         
		.o_xs-center { text-align: center !important; }       
		.o_xs-left { text-align: left !important; }         
		.o_xs-right { text-align: left !important; }         
		table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }          
		table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }         
		table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }     
		h1.o_heading { font-size: 32px !important; line-height: 41px !important; }      
		h2.o_heading { font-size: 26px !important; line-height: 37px !important; }         
		h3.o_heading { font-size: 20px !important; line-height: 30px !important; }         
		.o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }       
		.o_xs-pt-xs { padding-top: 8px !important; }       
		.o_xs-pb-xs { padding-bottom: 8px !important; }        }       
		@media screen {        
		@font-face {           
		font-family:''Roboto'';           
		font-style: normal;        
		font-weight: 400;        
		src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");        
		unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
		}      
		@font-face 
		{          
		font-family: ''Roboto'';         
		font-style: normal;          
		font-weight: 400;           
		src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");  
		unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
		}         
		@font-face 
		{           
		font-family: ''Roboto'';          
		font-style: normal;      
		font-weight: 700;          
		src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");  
		unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
		}         
		@font-face 
		{           
		font-family: ''Roboto'';     
		font-style: normal;           
		font-weight: 700;      
		src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");     
		unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; 
		}      
		.o_sans, .o_heading { font-family: "Roboto", sans-serif !important; 
		}         
		.o_heading, strong,
		b { font-weight: 700 !important; }        
		a[x-apple-data-detectors]
		{ color: inherit !important; text-decoration: none !important; }    
		}    
		</style>      
		</head>   
		<body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">     
		<!-- preview-text -->     
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">     
		<tbody>          
		<tr>        
		<td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)
		</td>  
		</tr>      
		</tbody>     
		</table>     
		<!-- header-white-link -->      
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">      
		<tbody>      
		<tr>           
		<td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">     
		<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->       
		<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;"> 
		<tbody>             
		<tr>                  
		<td class="o_re o_bg-white o_px o_pb-md o_br-t" align="center" style="font-size: 0;vertical-align: top;background-color: #ffffff;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">            
		<!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="200" align="left" valign="top" style="padding:0px 8px;"><![endif]-->  
		<div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">              
		<div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp;
		</div>                     
		<div class="o_px-xs o_sans o_text o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;text-align: left;padding-left: 8px;padding-right: 8px;">           
		<p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-primary" href="https://example.com/" style="text-decoration: none;outline: none;color: #126de5;"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
		</a>
		</p>                      
		</div>                     
		</div>         
		<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->               
		<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">             
		<div style="font-size: 22px; line-height: 22px; height: 22px;">&nbsp;
		</div>                   
		<div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">                       
		<table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">     
		<tbody>                            
		<tr>                          
		<td class="o_btn-b o_heading o_text-xs" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;mso-padding-alt: 7px 8px;">                   
		<a class="o_text-light" style="text-decoration: none;outline: none;color: #82899a;display: block;padding: 7px 8px;font-weight: bold;">
		<span style="mso-text-raise: 6px;display: inline;color: #82899a;">##AssigneeName## </span> 
		<img src="images/person-24-light.png" width="24" height="24" alt="" style="max-width: 24px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
		</a>                               
		</td>                          
		</tr>                        
		</tbody>                     
		</table>                     
		</div>                  
		</div>                         
		</td> 
		</tr>               
		</tbody>             
		</table>           
		<!--[if mso]></td></tr></table><![endif]-->         
		</td>        
		</tr>       
		</tbody>    
		</table>    
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">       
		<tbody>    
		<tr>       
		<td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">       
		<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->           
		<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">    
		<tbody>             
		<tr>                 
		<td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">                  
		<table cellspacing="0" cellpadding="0" border="0" role="presentation">                  
		<tbody>       
		<tr>                  
		<td class="o_sans o_text o_text-white o_bg-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;color: #ffffff;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">                    
		<img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F452935-8736-41C9-BE73-FC4B1E226959" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">                     
		</td>                     
		</tr>                    
		<tr>                         
		<td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp;
		</td>                     
		</tr>                    
		</tbody>             
		</table>           
		<h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Interview Schedule confirmed</h2>                   
		</td>       
		</tr>    
		</tbody>      
		</table>       
		<!--[if mso]></td></tr></table><![endif]-->          
		</td>   
		</tr>     
		</tbody>    
		</table>    
		<!-- service-primary -->    
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">    
		<tbody>     
		<tr>         
		<td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">        
		<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->       
		<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">     
		<tbody>          
		<tr>               
		<td class="o_re o_bg-primary o_px o_pb-md" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;padding-left: 50px;padding-right: 16px;padding-bottom: 24px;">             
		<!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->                 
		<div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">           
		<div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp;
		</div>                    
		<div class="o_px-xs o_sans o_text o_text-white o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #ffffff;text-align: left;padding-left: 8px;padding-right: 8px;">                       
		<p class="o_mb-xxs" style="margin-top: 0px;margin-bottom: 4px;"><strong>##InterviewRound##</strong></p>               
		<p class="o_text-xs" style="font-size: 14px;line-height: 21px;margin-top: 0px;margin-bottom: 0px;">##InterviewDate## ##InterviewTime##</p>                
		</div>                  
		</div>                  
		<!--[if mso]></td><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->                    
		<div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">      
		<div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp;
		</div>                      
		<div class="o_px-xs o_right o_xs-center" style="text-align: right;padding-left: 8px;padding-right: 8px;">        
		<table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">        
		<tbody>                         
		<tr>                            
		<td class="o_btn o_bg-white o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #ffffff;border-radius: 4px;">               
		</td>                    
		</tr>                         
		</tbody>                     
		</table>                  
		</div>                   
		<!--[if mso]></td></tr></table><![endif]-->    
		</div>
		</td>      
		</tr>           
		</tbody>           
		</table>           
		<!--[if mso]></td></tr></table><![endif]-->      
		</td>      
		</tr>   
		</tbody>    
		</table>  
		<!-- spacer -->   
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">    
		<tbody>     
		<tr>          
		<td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">        
		<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->     
		<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;"> 
		<tbody>             
		<tr>              
		<td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>  
		</tr>      
		</tbody>        
		</table>         
		<!--[if mso]></td></tr></table><![endif]-->       
		</td> 
		</tr>     
		</tbody>  
		</table>   
		<!-- content -->    
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">     
		<tbody>      
		<tr>          
		<td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">     
		<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->      
		<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">  
		<tbody>                  <tr>                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">                      <p style="margin-top: 0px;margin-bottom: 0px;">The interview which was scheduled on the above date was confirmed</p>                    </td>                  </tr>                </tbody>              </table>              <!--[if mso]></td></tr></table><![endif]-->            </td>          </tr>        </tbody>      </table>      <!-- spacer -->      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">        <tbody>          <tr>            <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">              <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">                <tbody>                  <tr>                    <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>                  </tr>                </tbody>              </table>              <!--[if mso]></td></tr></table><![endif]-->            </td>          </tr>        </tbody>      </table>      <!-- footer-white-3cols -->       <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">                <tbody>                  <tr>                    <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">                      <div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">                        <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>                        <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">                          <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>       <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>                      <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>       <p style="margin-top: 0px;margin-bottom: 0px;">                            Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a>                         </p>                        </div>                      </div>                      <!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->                      <div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">                        <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>                        <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">                          <p style="margin-top: 0px;margin-bottom: 0px;">                            <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                          </p>                        </div>                      </div>                     </td>                  </tr>                </tbody>              </table>    </body>  </html>  
													',	GETDATE(),@UserId,@CompanyId)
        )
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.[TemplateName] = Source.[TemplateName]  AND Target.[CompanyId] = Source.[CompanyId]
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);

MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES
	(NEWID(),N'By using this app user can see all the Interview processes for the site,can add Interview processes and edit the Interview processes.Also users can view the archived Interview processes and can search and sort the Interview processes from the list.', N'Interview process', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	)
	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.[WidgetName] = Source.[WidgetName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN 
	UPDATE SET [WidgetName] = Source.[WidgetName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] =  Source.[CompanyId],
			   [Description] =  Source.[Description],
			   [UpdatedDateTime] =  Source.[UpdatedDateTime],
			   [UpdatedByUserId] =  Source.[UpdatedByUserId],
			   [InActiveDateTime] =  Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
	(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Interview process' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
	)
	AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
WHEN MATCHED THEN 
UPDATE SET
		   [WidgetId] = Source.[WidgetId],
		   [ModuleId] = Source.[ModuleId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);	

MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                (NEWID(),'InterviewScheduleApprovalTemplate',
        '<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Service Confirmation</title>
    <style type="text/css">
      a { text-decoration: none; outline: none; }
      @media (max-width: 649px) {
        .o_col-full { max-width: 100% !important; }
        .o_col-half { max-width: 50% !important; }
        .o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }
        .o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }
        .o_xs-center { text-align: center !important; }
        .o_xs-left { text-align: left !important; }
        .o_xs-right { text-align: left !important; }
        table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }
        table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }
        table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }
        h1.o_heading { font-size: 32px !important; line-height: 41px !important; }
        h2.o_heading { font-size: 26px !important; line-height: 37px !important; }
        h3.o_heading { font-size: 20px !important; line-height: 30px !important; }
        .o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }
        .o_xs-pt-xs { padding-top: 8px !important; }
        .o_xs-pb-xs { padding-bottom: 8px !important; }
      }
      @media screen {
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
        .o_heading, strong, b { font-weight: 700 !important; }
        a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
      }
    </style>
    
  </head>
  <body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
    <!-- preview-text -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)</td>
        </tr>
      </tbody>
    </table>
    <!-- header-white-link -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_re o_bg-white o_px o_pb-md o_br-t" align="center" style="font-size: 0;vertical-align: top;background-color: #ffffff;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">
                    <!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="200" align="left" valign="top" style="padding:0px 8px;"><![endif]-->
                    <div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_sans o_text o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;text-align: left;padding-left: 8px;padding-right: 8px;">
                        <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-primary" style="text-decoration: none;outline: none;color: #126de5;"><img src="##CompanyLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
                      </div>
                    </div>
                    <!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
                    <div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                      <div style="font-size: 22px; line-height: 22px; height: 22px;">&nbsp; </div>
                      <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
                        <table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">
                          <tbody>
                            <tr>
                              <td class="o_btn-b o_heading o_text-xs" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;mso-padding-alt: 7px 8px;">
                                <a class="o_text-light" style="text-decoration: none;outline: none;color: #82899a;display: block;padding: 7px 8px;font-weight: bold;"><span style="mso-text-raise: 6px;display: inline;color: #82899a;">##AssigneeName## </span> <img src="images/person-24-light.png" width="24" height="24" alt="" style="max-width: 24px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    </div>
                    
                  </td>
                </tr>
              </tbody>
            </table>
            <!--[if mso]></td></tr></table><![endif]-->
          </td>
        </tr>
      </tbody>
    </table>
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                    <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                      <tbody>
                        <tr>
                          <td class="o_sans o_text o_text-white o_bg-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;color: #ffffff;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                            <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F452935-8736-41C9-BE73-FC4B1E226959" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                          </td>
                        </tr>
                        <tr>
                          <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                        </tr>
                      </tbody>
                    </table>
                    <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">##TemplateName##</h2>                    
                  </td>
                </tr>
              </tbody>
            </table>
            <!--[if mso]></td></tr></table><![endif]-->
          </td>
        </tr>
      </tbody>
    </table>
    <!-- service-primary -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_re o_bg-primary o_px o_pb-md" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">
                    <!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_sans o_text o_text-white o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #ffffff;text-align: left;padding-left: 8px;padding-right: 8px;">
                        <p class="o_mb-xxs" style="margin-top: 0px;margin-bottom: 4px;"><strong>##InterviewRound##</strong></p>
                        <p class="o_text-xs" style="font-size: 14px;line-height: 21px;margin-top: 0px;margin-bottom: 0px;">##InterviewDate## ##InterviewTime##</p>
                      </div>
                    </div>
                    <!--[if mso]></td><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_right o_xs-center" style="text-align: right;padding-left: 8px;padding-right: 8px;">
                        <table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">
                          <tbody>
                            <tr>
                              <td class="o_btn o_bg-white o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #ffffff;border-radius: 4px;">
                                <a class="o_text-primary" href=''##ApprovalUrl##'' style="text-decoration: none;outline: none;color: #126de5;display: block;padding: 12px 24px;mso-text-raise: 3px;">##ButtonName##</a>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                    </div>
                    <!--[if mso]></td></tr></table><![endif]-->
                  </div></td>
                </tr>
              </tbody>
            </table>
            <!--[if mso]></td></tr></table><![endif]-->
          </td>
        </tr>
      </tbody>
    </table>
    <!-- spacer -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                </tr>
              </tbody>
            </table>
            <!--[if mso]></td></tr></table><![endif]-->
          </td>
        </tr>
      </tbody>
    </table>
    <!-- content -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
                    <p style="margin-top: 0px;margin-bottom: 0px;">##Description##</p>
                  </td>
                </tr>
              </tbody>
            </table>
            <!--[if mso]></td></tr></table><![endif]-->
          </td>
        </tr>
      </tbody>
    </table>
    <!-- spacer -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                </tr>
              </tbody>
            </table>
            <!--[if mso]></td></tr></table><![endif]-->
          </td>
        </tr>
      </tbody>
    </table>
    <!-- footer-white-3cols -->
     <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
                    <div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
                      <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                      <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
                        <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>
					<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>
                    <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>
					<p style="margin-top: 0px;margin-bottom: 0px;">
                          Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
                      </p>
                      </div>
                    </div>
                    <!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
                    <div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                      <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                      <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                        <p style="margin-top: 0px;margin-bottom: 0px;">
                          <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
                          <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
                          <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
                        </p>
                      </div>
                    </div>
                   </td>
                </tr>
              </tbody>
            </table>
  </body>
</html>
',
														GETDATE(),@UserId,@CompanyId)
        )
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.[TemplateName] = Source.[TemplateName]  AND Target.[CompanyId] = Source.[CompanyId]
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);


		MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
   (NEWID(), N'Candidates By Status','This app provides the count of candidates for each hiring status. User can download the information',
   'SELECT HS.[Status],COUNT(1) [Candidates Counts]  FROM [Candidate] C 
   INNER JOIN [CandidateJobOpening] CJ ON C.Id = CJ.CandidateId AND CJ.InActiveDateTime IS NULL 
                            INNER JOIN HiringStatus HS ON HS.Id = CJ.HiringStatusId AND C.InActiveDateTime IS NULL
							INNER JOIN JobOpening JO ON JO.Id = CJ.JobOpeningId AND JO.InActiveDateTime IS NULL 
							WHERE HS.CompanyId = ''@CompanyId''
							    AND (''@HiringStatusId'' = '''' OR HS.Id = ''@HiringStatusId'')
								AND (''@CandidateId'' = '''' OR C.Id = ''@CandidateId'')
							    AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))  
							GROUP BY HS.[Status]', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))	
   ,(NEWID(), N'Candidates By Ownership','This app provides the count of count of candidates for each assigned owner and user can download the information',
   N'SELECT U.FirstName+'' ''+U.SurName [Candidate Owner] ,COUNT(1) [Ownership Counts]  FROM [Candidate] C
          INNER JOIN [CandidateJobOpening] CJ ON C.Id = CJ.CandidateId AND CJ.InActiveDateTime IS NULL
                          INNER JOIN [USER]U ON U.Id  = C.AssignedToManagerId AND C.InActiveDateTime IS NULL 
						  INNER JOIN JobOpening JO ON JO.Id = CJ.JobOpeningId AND JO.InActiveDateTime IS NULL
							WHERE U.CompanyId = ''@CompanyId''
							  AND (''@CandidateId'' = '''' OR C.Id = ''@CandidateId'')
							  AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
							 AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))  
							GROUP BY U.FirstName+'' ''+U.SurName', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))
	,(NEWID(), N'Candidates By Source','This app provides the count of candidates for each source.Users can download the information and change the visualization of the app.', 
	  'SELECT S.[Name] AS Source,COUNT(1) [Candidate Counts]  FROM [Candidate] C 
	   INNER JOIN [CandidateJobOpening] CJ ON C.Id = CJ.CandidateId AND CJ.InActiveDateTime IS NULL
       INNER JOIN [Source] S ON S.Id = C.SourceId AND C.InActiveDateTime IS NULL
	    INNER JOIN JobOpening JO ON JO.Id = CJ.JobOpeningId AND JO.InActiveDateTime IS NULL
       WHERE S.CompanyId = ''@CompanyId''
	        AND (''@CandidateId'' = '''' OR C.Id = ''@CandidateId'')
	        AND (''@SourceId'' = '''' OR C.SourceId = ''@SourceId'')
            AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(C.CreatedDateTime  AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
            AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(C.CreatedDateTime  AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))      
       GROUP BY S.[Name]', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))

)
	AS Source ([Id],[CustomWidgetName],[Description] , [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],
			    [Description] =  Source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id],[Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);

END
GO