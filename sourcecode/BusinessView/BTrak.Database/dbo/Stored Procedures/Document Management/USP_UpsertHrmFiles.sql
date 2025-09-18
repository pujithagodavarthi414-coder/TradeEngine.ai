---------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-11-12 00:00:00.000'
-- Purpose      To Upsert Hrm Files
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertHrmFiles] 
--@FilesXML='<GenericListOfFileModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
---<ListItems>
---<FileModel>
--<FileId xsi:nil="true"/>
--<FileName>image (6).png</FileName>
--<FileSize>46584</FileSize>
--<FilePath>https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/hrm/0b2921a9-e930-4013-9047-670b5352f308/image_(6)-6942b197-443a-47c8-9e2d-d251f964ebc5.png</FilePath>
--<FileExtension>.png</FileExtension>
--<IsArchived>false</IsArchived>
--</FileModel>
---<FileModel>
--<FileId xsi:nil="true"/>
--<FileName>image.png</FileName>
--<FileSize>113683</FileSize>
--<FilePath>https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/hrm/0b2921a9-e930-4013-9047-670b5352f308/image-2890dd63-a926-44ef-8e5a-0b4b5de2e6ae.png</FilePath>
--<FileExtension>.png</FileExtension>
--<IsArchived>false</IsArchived>
--</FileModel>
--</ListItems>
--</GenericListOfFileModel>'
--,@ReferenceId= 'a4561496-0e0e-479e-a9a8-d305d7b415eb',@ReferenceTypeId='7c246f5a-12b3-4938-8208-ad572044cd48',@OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308'
---------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertHrmFiles]
(
   @FilesXML XML = NULL,
   @FolderId UNIQUEIDENTIFIER = NULL,
   @StoreId UNIQUEIDENTIFIER = NULL,
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        IF(@FolderId = '00000000-0000-0000-0000-000000000000') SET @FolderId = NULL

        IF(@StoreId = '00000000-0000-0000-0000-000000000000') SET @StoreId = NULL

		IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL

		IF(@ReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @ReferenceTypeId = NULL

        IF(@ReferenceTypeId IS NULL OR  @ReferenceTypeId = '00000000-0000-0000-0000-000000000000')
        BEGIN
           
            RAISERROR(50011,16, 2, 'ReferenceTypeId')
        
        END
		ELSE IF(@ReferenceId IS NULL OR  @ReferenceId = '00000000-0000-0000-0000-000000000000')
        BEGIN
    
            RAISERROR(50011,16, 2, 'ReferenceId')
    
        END
        ELSE 
        BEGIN

			DECLARE @ReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType  WHERE Id = @ReferenceTypeId AND InActiveDateTime IS NULL)
       
			IF(@ReferenceTypeIdCount = 0 AND @ReferenceTypeId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'ReferenceTypeId')
            
            END
            ELSE
            BEGIN

				DECLARE @ReferenceTypeName NVARCHAR(250) = (SELECT ReferenceTypeName FROM ReferenceType WHERE Id = @ReferenceTypeId)

				DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				IF (@HavePermission = '1')
				BEGIN	
				
					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				    
					SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )

					DECLARE @FolderName NVARCHAR(50) = CASE WHEN @ReferenceTypeName = 'Identification'				THEN (SELECT E.EmployeeNumber FROM Employee E JOIN EmployeeLicence EL ON EL.Id = @ReferenceId AND EL.EmployeeId = E.Id)
															WHEN @ReferenceTypeName = 'Personal details'	THEN (SELECT E.EmployeeNumber FROM Employee E WHERE E.Id = @ReferenceId AND InActiveDateTime IS NULL)
															WHEN @ReferenceTypeName = 'Emergency contacts'	THEN (SELECT E.EmployeeNumber FROM Employee E JOIN EmployeeEmergencyContact EEC ON EEC.Id = @ReferenceId AND EEC.EmployeeId = E.Id)
															WHEN @ReferenceTypeName = 'Immigration'			THEN (SELECT E.EmployeeNumber FROM Employee E JOIN EmployeeImmigration EI ON EI.Id = @ReferenceId AND EI.EmployeeId = E.Id)
															WHEN @ReferenceTypeName = 'Contract'			THEN (SELECT E.EmployeeNumber FROM Employee E JOIN [Contract] C ON C.Id = @ReferenceId AND C.EmployeeId = E.Id)
															WHEN @ReferenceTypeName = 'Salary'				THEN (SELECT E.EmployeeNumber FROM Employee E JOIN EmployeeSalary ES ON ES.Id = @ReferenceId AND ES.EmployeeId = E.Id)
															WHEN @ReferenceTypeName = 'Work experience'		THEN (SELECT E.EmployeeNumber FROM Employee E JOIN EmployeeWorkExperience EWE ON EWE.Id = @ReferenceId AND EWE.EmployeeId = E.Id)
															WHEN @ReferenceTypeName = 'Education'			THEN (SELECT E.EmployeeNumber FROM Employee E JOIN EmployeeEducation EE ON EE.Id = @ReferenceId AND EE.EmployeeId = E.Id)
															WHEN @ReferenceTypeName = 'Membership'			THEN (SELECT E.EmployeeNumber FROM Employee E JOIN EmployeeMembership EM ON EM.Id = @ReferenceId AND EM.EmployeeId = E.Id)
															WHEN @ReferenceTypeName = 'Leaves'				THEN (SELECT E.EmployeeNumber FROM Employee E JOIN LeaveApplication LA ON LA.Id = @ReferenceId AND E.UserId = LA.UserId)
															WHEN @ReferenceTypeName = 'Solar log'				THEN (SELECT SolarLogValue From SolarLogForm WHERE Id = @ReferenceId)
													   END
					DECLARE @ParentFolderId UNIQUEIDENTIFIER = CASE	WHEN @ReferenceTypeName = 'Identification'				THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Identification details'	)
																	WHEN @ReferenceTypeName = 'Personal details'	THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Personal details')
																	WHEN @ReferenceTypeName = 'Emergency contacts'	THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Emergency contacts details')
																	WHEN @ReferenceTypeName = 'Immigration'			THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Immigration details')
																	WHEN @ReferenceTypeName = 'Contract'			THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Contract details'	)
																	WHEN @ReferenceTypeName = 'Salary'				THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Salary details'		)
																	WHEN @ReferenceTypeName = 'Work experience'		THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Work experience details')
																	WHEN @ReferenceTypeName = 'Education'			THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Education details'	)
																	WHEN @ReferenceTypeName = 'Membership'			THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Membership details'	)
																	WHEN @ReferenceTypeName = 'Leaves'				THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Leaves'	)
																	WHEN @ReferenceTypeName = 'Solar log'				THEN (SELECT Id FROM Folder WHERE StoreId = @StoreId AND InActiveDateTime IS NULL AND FolderName = 'Solar log'	)
																END

					DECLARE @FolderCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderName = @FolderName AND ParentFolderId = @ParentFolderId AND InActiveDateTime IS NULL)
				
					IF(@FolderCount = 0)
					BEGIN

						DECLARE @Temp Table ( Id UNIQUEIDENTIFIER )
				    
					    INSERT INTO @Temp(Id) 
						EXEC [USP_UpsertFolder] @FolderName = @FolderName,@ParentFolderId= @ParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
				    
						SELECT TOP(1) @FolderId =  Id FROM @Temp
						
					END
					ELSE
					BEGIN
						
						SET @FolderId = (SELECT Id FROM Folder WHERE FolderName = @FolderName AND ParentFolderId = @ParentFolderId AND InActiveDateTime IS NULL)

					END

					EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @FolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL
				
				END       
				ELSE
				BEGIN

					RAISERROR (@HavePermission,11, 1)

				END
			END
        END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO