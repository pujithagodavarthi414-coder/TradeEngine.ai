using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace Btrak.Services.File
{
    public interface IFileService
    {
        void SaveFile(FilesModel filesModel, LoggedInContext loggedInContext);
        IList<FilesModel> GetUserStoriesRelatedFiles(Guid userStoryId);
    }
}
