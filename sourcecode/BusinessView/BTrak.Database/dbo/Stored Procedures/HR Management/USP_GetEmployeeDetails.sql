-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-08-16 00:00:00.000'
-- Purpose      To Get EmployeeDetails By Employee Id
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEmployeeDetails] @OperationsPerformedBy='3f16feca-5f00-4aed-bc23-638e8596c607',
-- @UserId = '3f16feca-5f00-4aed-bc23-638e8596c607'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetEmployeeDetails]
(
    @UserId UNIQUEIDENTIFIER,
    @OperationsPerformedBy  UNIQUEIDENTIFIER
)
AS
BEGIN
   SET NOCOUNT ON
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   BEGIN TRY
        
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF(@UserId IS NULL)
            RAISERROR(50002,16, 1,'User')
        
        IF (@HavePermission = '1')
        BEGIN
          
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		       DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)

           SELECT
				U.Id AS UserId,
				U.FirstName,
				U.SurName,
				U.UserName Email,
				U.MobileNo,
				U.ProfileImage,
				U.IsActive,
				C.CompanyName,
				C.CompanyWebsite,
				C.Note,
				CA.Street,
				CA.City,
				CA.[State],
				CA.Zipcode,
				CO.CountryName,
				B.BranchName,
				D.DesignationName,
				STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),UR.RoleId))
                                FROM UserRole UR
                                     INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                                AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                                WHERE UR.UserId = U.Id
                                ORDER BY RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleIds,
                STUFF((SELECT ', ' + RoleName 
                                FROM UserRole UR
                                     INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                                AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                                WHERE UR.UserId = U.Id
                                ORDER BY RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
				(SELECT EE.Institute
                        ,EL.EducationLevel
                        ,EE.MajorSpecialization
                        ,EE.StartDate
                        ,EE.EndDate 
                  FROM EmployeeEducation EE 
				  INNER JOIN Employee E ON E.Id = EE.EmployeeId AND E.UserId = @UserId AND E.InActiveDateTime IS NULL
                  INNER JOIN EducationLevel EL ON EL.Id = EE.EducationLevelId AND EE.EmployeeId = E.Id 
                                         AND EE.InActiveDateTime IS NULL 
                                         AND EL.InactiveDateTime IS NULL
										 
                   ORDER BY EE.EndDate DESC
                   FOR JSON PATH,ROOT('EmployeeEducation')) AS Education
				,(SELECT EWE.Company
                         ,D.DesignationName
                         ,EWE.FromDate
                         ,EWE.ToDate    
                     FROM EmployeeWorkExperience EWE
					 INNER JOIN Employee E ON E.Id = EWE.EmployeeId AND E.UserId =@UserId AND E.InActiveDateTime IS NULL
                          INNER JOIN Designation D ON D.Id = EWE.DesignationId
                                   AND EWE.InActiveDateTime IS NULL
                                   AND D.InActiveDateTime IS NULL
					ORDER BY EWE.ToDate DESC
                    FOR JSON PATH,ROOT('EmployeeWorkExperience')) AS Experience
                 ,(SELECT S.SkillName 
                      FROM EmployeeSkill ES
					  INNER JOIN Employee E ON E.Id = ES.EmployeeId AND E.UserId= @UserId AND E.InActiveDateTime IS NULL
                           INNER JOIN Skill S ON S.Id = ES.SkillId
                                    AND ES.InActiveDateTime IS NULL 
                                    AND S.InActiveDateTime IS NULL
                       ORDER BY S.SkillName
                     FOR JSON PATH,ROOT('EmployeeSkill')) AS Skill
				 ,(SELECT L.LanguageName 
                      FROM EmployeeLanguage EL
					  INNER JOIN Employee E ON E.Id = EL.EmployeeId AND E.UserId=@UserId AND E.InActiveDateTime IS NULL
                           INNER JOIN [Language] L ON L.Id = EL.LanguageId
                                    AND EL.InActiveDateTime IS NULL 
                                    AND L.InActiveDateTime IS NULL
                      ORDER BY L.LanguageName
                    FOR JSON PATH,ROOT('EmployeeLanguage')) AS 'Language'
                  ,(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS ReportingEmployeeFullName 
                      FROM EmployeeReportTo ERT
					  INNER JOIN Employee EE ON EE.Id = ERT.EmployeeId AND EE.UserId =@UserId AND EE.InActiveDateTime IS NULL
					  INNER JOIN Employee E ON E.Id = ERT.ReportToEmployeeId AND ERT.EmployeeId = EE.Id 
                                             AND ERT.InActiveDateTime IS NULL 
                                             AND E.InActiveDateTime IS NULL
                           INNER JOIN [User] U ON U.Id = E.UserId 
                                             AND U.InActiveDateTime IS NULL
						 ORDER BY U.FirstName + ' ' + ISNULL(U.SurName,'') 
                    FOR JSON PATH,ROOT('EmployeeReportTo')) AS ReportTo
					,U.[TimeStamp]
					FROM [User] U
						LEFT JOIN Client C ON C.UserId = U.Id AND C.InActiveDateTime IS NULL
						LEFT JOIN ClientAddress CA ON CA.ClientId = C.Id  AND CA.InActiveDateTime IS NULL
						LEFT JOIn Country CO ON CO.Id = CA.CountryId 
						LEFT JOIN Employee E ON E.UserId = U.Id  AND E.InActiveDateTime IS NULL
						LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] <= GETDATE() AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
						LEFT JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
						LEFT JOIN Job J ON J.EmployeeId = E.Id AND J.InActiveDateTime IS NULL
						LEFT JOIN Designation D ON D.Id = J.DesignationId AND D.InActiveDateTime IS NULL
					WHERE U.Id = @UserId AND (U.InActiveDateTime IS NULL OR @IsSupport = 1)
							AND U.CompanyId = @CompanyId
        END
        ELSE
        BEGIN
        
                RAISERROR (@HavePermission,11, 1)
                
        END
   END TRY
   BEGIN CATCH
       
       THROW
   END CATCH
    
END
GO