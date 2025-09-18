using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.TestRail;
using BTrak.Common;

namespace Btrak.Services.TestRail
{
    public interface ITestRailFileService
    {
        List<Guid?> UpsertFile(TestRailFileModel testRailFileModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        TestRailFileModel GetTestRailFileById(Guid? testRailFileId, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);

        List<TestRailFileModel> SearchTestRailFiles(TestRailFileModel testRailFileModel,LoggedInContext loggedInContext);
    }
}
