CREATE VIEW [dbo].[V_Comments] AS 
SELECT CPNY.CompanyName, 
	   U.FirstName + ' ' + U.SurName UserFullName, 
	   C.Comment, 
	   PC.Comment ParentComment, 
	   US.Id UserStoryId, 
	   US.UserStoryName, 
	   C.CreatedDateTime
FROM [dbo].[Comment] C
	 INNER JOIN [dbo].[User] U ON C.CommentedByUserId = U.Id
	 INNER JOIN [dbo].[Company] CPNY ON CPNY.Id = U.CompanyId
	 LEFT OUTER JOIN [dbo].[Comment] PC ON PC.Id = C.ParentCommentId
	 LEFT OUTER JOIN [dbo].[UserStory] US ON US.Id = C.ReceiverId
