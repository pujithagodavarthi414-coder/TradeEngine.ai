CREATE PROCEDURE [dbo].[Marker45]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 



MERGE INTO [dbo].[DocumentTemplates] AS Target 
        USING ( VALUES 
(NEWID(),'Business Analyst offer letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Business_Analyst_Offer_letter-429e4988-092e-4786-9184-977ce4a5dc66.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Business development manager offer letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Busuness_Development_Manager_offer_letter-86f2e548-49c4-43d2-8248-9ccc2b5c06f4.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Contract Employee Offer Letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Contract_Employee_Offer_Letter-1bb2b5f9-8645-41c7-8e62-003d8407a04d.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Employee Termination Letter Without Probation clearence - Probation Not Completed','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Employee_Termination_Letter_Without_Probation_clearence_-_Probation_Not_Completed-fcbdb358-adb2-44b6-b42a-8d7de6a4eb01.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Experience Letter of HR','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Experience_Letter_of_HR-b6a9a412-d624-438d-9110-dff94fee8925.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Experirence Letter of Developer','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Experirnce_Letter_of_Developer-d25d702e-e636-4d57-b446-81135ce8c0e7.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Fresher Appointment letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Fresher_Appointment_letter-a6badca4-e1e4-4ea3-a3fb-73a9b5dd0314.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Fresher Offer letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Fresher_Offer_letter-01b84dc5-d41a-4408-8492-cba2b9db0285.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Internship Completion Letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Internship_Completion_Letter-7d06d0c4-36e1-4ae8-a7b6-98d5b71b2864.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Internship Invitation Letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Internship_Invitation_Letter-63d48feb-e99b-4dd1-bf90-176ffd930da6.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Junior Developer Offer Letter With Special Allowance','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Junior_Developer_Offer_Letter_With_Special_Allowance-bc7d4b8c-3e95-44b3-b957-bcc881818e2e.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Lead Generation Executive offer letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Lead_Generation_Executive_offer_letter-3517162e-3614-4264-bb79-d9d38e387aa6.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Non Disclosure Agreement new','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Non_Disclosure_Agreement_new-efd3a01a-15eb-40af-baa6-e84779169c9b.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Poor Performance review letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Poor_Performance_review_letter-55eb2716-81cf-491c-8c6e-f788cc7dee32.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Prohibition completion letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Prohibition_completion_letter-8a1b6558-dfad-4350-abb1-95242a51666e.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'QA offer letter Juniors','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/QA_offer_letter_Juniors-0dd86e7b-e124-4a73-91f1-7f3ed7ca5bff.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Salary Hike And Special Allowance Letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Non_Disclosure_Agreement_new-efd3a01a-15eb-40af-baa6-e84779169c9b.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Self Confirmation For Certificate Submission of candidate','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Self_Confirmation_For_Certificate_Submissionof_candidate-4262bc51-f3a6-485e-8208-cb30a28df521.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Senior QA offer letter with Bond','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Senior_QA_offer_letter_with_Bond-131bf1c8-17d8-4e5a-954a-32dc692a7cb8.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Seniors Developer Offer Letter Without Bond','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Seniors_Developer_Offer_Letter_Without_Bond-6eb6f7a9-597a-4805-b56c-43dab5b78503.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Snovasys Company Requested Resignation Letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Snovasys_Company_Requested_Resignation_Letter-f6c48c29-cf39-4c1e-a3fa-ceea874437ca.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Snovasys Exit Interview','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Snovasys_Exit_Interview-88ceeaa7-a455-4e40-9f74-13d27c7d8587.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Snovasys Hike Letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Snovasys_Hike_Letter-13b42283-60d1-46ed-b5d6-227cd3611882.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Snovasys Relieving Letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Snovasys_Relieving_Letter-a3ba59f7-6dfa-4c42-8090-a51c19e2f5aa.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Suspend Letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Suspend_Letter-177ccf6d-c3f6-40c6-a77d-90bce28f3c59.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Warning letter','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Warning_letter-8411a437-0d20-4429-8127-898fa0d32247.docx',GETDATE(),@UserId,@CompanyId),

(NEWID(),'Work From Home Policy','https://bviewstorage.blob.core.windows.net/51c57ac3-c0c3-421f-9981-7fe0ffb26f98/localsiteuploads/121aaf8e-ac99-4802-b8c1-39d57cad2112/Work_From_Home_Policy-a3e26929-3b7e-43d8-b1ea-80cfe1d71e79.docx',GETDATE(),@UserId,@CompanyId)
)
        AS Source ([Id],[TemplateName], [TemplatePath], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.Id = Source.Id  
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [TemplatePath] = Source.[TemplatePath],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [TemplatePath], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [TemplatePath], [CreatedDateTime], [CreatedByUserId],[CompanyId]);

MERGE INTO [dbo].[Widget] AS Target 
		USING ( VALUES 
			(NEWID(), 'This app allows to view thedocument templates and also allows you to generate the templates based on the selected user', N'Document Templates',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
		)
		AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
		ON Target.Id = Source.Id 
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
		VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;

END
