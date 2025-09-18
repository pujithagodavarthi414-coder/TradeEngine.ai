/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

EXEC [USP_MasterDataDeploymentScript]

EXEC [USP_ExecutePermissionsMatrix]

EXEC [USP_ExecuteFeatureProcedureScript]

EXEC sp_addmessage @msgnum = 50001,
             @severity = 16,
             @msgtext = N'%sWithThisNameAlreadyExists',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50002,
            @severity = 16,
            @msgtext = N'%sDataIsNotFound',
             @replace = 'replace';

EXEC sp_addmessage @msgnum = 50003,
             @severity = 16,
             @msgtext = N'AlreadyHaveAccessForThisProjectWithThisRole',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50004,
             @severity = 16,
             @msgtext = N'ThisUserAccountIsNotExist',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50005,
             @severity = 16,
             @msgtext = N'ThisFeatureisNotExist',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50006,
             @severity = 16,
             @msgtext = N'%sThisFeatureDoNotBelongToYourCompanyFeatures',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50007,
             @severity = 16,
             @msgtext = N'YouDoNotHavePermissionsTo',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50008,
             @severity = 16,
             @msgtext = N'ThisRecordIsAlreadyUpdatedPleaseRefreshThePageForNewChanges',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50009,
             @severity = 16,
             @msgtext = N'ThisColorIsAlreadyAssignedToAStatusInTheSystemPleaseSelectAnotherColor',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50010,
             @severity = 16,
             @msgtext = N'%sWithThisEmailAlreadyExists',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50011,
             @severity = 16,
             @msgtext = N'%sShouldNotBeNull',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50012,
             @severity = 16,
             @msgtext = N'EmployeeWithSameDetailsAlreadyExists',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50013,
             @severity = 16,
             @msgtext = N'PleaseCheckEmployeeAndReportingEmployeeAreSame',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50014,
             @severity = 16,
             @msgtext = N'EmailIsNotAvailablePleaseCheckTheEmailYouHaveEntered',
			 @replace = 'replace';

EXEC sp_addmessage @msgnum = 50015,
             @severity = 16,
             @msgtext = N'ThisRecordIsAlreadyDeletedPleaseRefreshThePageForNewChanges',
			 @replace = 'replace';
             
EXEC sp_addmessage @msgnum = 50016,
             @severity = 16,
             @msgtext = N'LeaveAlreadyExists',
			 @replace = 'replace';
GO

EXEC sp_addmessage @msgnum = 50017,
             @severity = 16,
             @msgtext = N'BeforeYouDeleteTheBranchPleaseDeleteAllTheBranchMembers',
			 @replace = 'replace';
GO

EXEC sp_addmessage @msgnum = 50018,
             @severity = 16,
             @msgtext = N'PleaseSelectValidFinishTime',
			 @replace = 'replace';
GO

EXEC sp_addmessage @msgnum = 50020,
             @severity = 16,
             @msgtext = N'EmployeeContractStartOrEndDateMatchesWithOtherStartDateOrEndDate',
			 @replace = 'replace';
GO

EXEC sp_addmessage @msgnum = 50021,
             @severity = 16,
             @msgtext = N'SpentTimeCantBeTooLow',
			 @replace = 'replace';
GO

EXEC sp_addmessage @msgnum = 50022,
             @severity = 16,
             @msgtext = N'EstimateCantBeNegativeOrZero',
			 @replace = 'replace';
GO

EXEC sp_addmessage @msgnum = 50023,
             @severity = 16,
             @msgtext = N'InsufficientBalanceToPurchase',
			 @replace = 'replace';
GO

EXEC sp_addmessage @msgnum = 50024,
             @severity = 16,
             @msgtext = N'PleaseDoNotEnterDuplicateNames',
			 @replace = 'replace';
GO

EXEC sp_addmessage @msgnum = 50025,
             @severity = 16,
             @msgtext = N'PleaseSelectTaskStatus',
			 @replace = 'replace';
GO

EXEC sp_addmessage @msgnum = 50026,
             @severity = 16,
             @msgtext = N'%sIsArchived',
			 @replace = 'replace';
GO


EXEC sp_addmessage @msgnum = 50027,
             @severity = 16,
             @msgtext = N'%s',
			 @replace = 'replace';
GO