using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;

namespace Btrak.Services.File
{
    public class FileService : IFileService
    {
        private readonly FileRepository _fileRepository = new FileRepository();

        public void SaveFile(FilesModel filesModel, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Or Update UserStory", "UserStory Service"));

                FileDbEntity fileDbEntity = new FileDbEntity
                {
                    Id = Guid.NewGuid(),
                    UserStoryId = filesModel.UserStoryId,
                    FileName = filesModel.FileName,
                    FilePath = filesModel.FilePath,
                    CreatedByUserId = loggedInContext.LoggedInUserId,
                    CreatedDateTime = DateTime.Now
                };

                //_fileRepository.Insert(fileDbEntity);
            }
            catch (Exception exception)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Add Or Update UserStory", "UserStory Service", exception));

                throw;
            }
        }

        public IList<FilesModel> GetUserStoriesRelatedFiles(Guid userStoryId)
        {
            return _fileRepository.SelectFileByUserStoryId(userStoryId);
        }
    }
}
