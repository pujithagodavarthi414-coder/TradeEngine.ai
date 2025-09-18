using Btrak.Models;
using Btrak.Models.Projects;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.Chat;

namespace Btrak.Services.Projects
{
    public interface IProjectMemberService
    {
        List<Guid> UpsertProjectMember(ProjectMemberUpsertInputModel projectMemberUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProjectMemberApiReturnModel> GetAllProjectMembers(ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ProjectMemberApiReturnModel GetProjectMemberById(Guid? projectMemberId,Guid? projectId, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        ProjectAndChannelApiReturnModel UpsertProjectAndChannelMembers(ChannelUpsertInputModel channelModel, ProjectMemberUpsertInputModel projectMemberUpsertInputModel,  LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        DeleteProjectMemberOutputModel DeleteProjectMember(DeleteProjectMemberModel deleteProjectMemberModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
