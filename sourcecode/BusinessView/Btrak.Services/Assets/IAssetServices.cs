using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Btrak.Models;
using Btrak.Models.Assets;
using Btrak.Models.SeatingArrangement;
using BTrak.Common;

namespace Btrak.Services.Assets
{
    public interface IAssetServices
    {
        Guid? UpsertAsset(AssetsInputModel assetDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AssetsOutputModel> SearchAllAssets(AssetSearchCriteriaInputModel assetSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSeatingArrangement(SeatingArrangementInputModel seatingModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? GetAssetsCount(AssetSearchCriteriaInputModel assetSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        AssetsOutputModel GetMyAsset(Guid UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SeatingArrangementOutputModel> GetAllSeatingArrangement(SeatingSearchCriteriaInputModel seatingSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AssetDetailsModel> GetAllAssets(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SeatingArrangementOutputModel GetSeatingArrangementById(Guid? seatingArrangementId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AssetsDashboardOutputModel> GetAllAssetsAssignedToEmployees(AssetSearchCriteriaInputModel assertSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AssetCommentsAndHistoryOutputModel> GetCommentsAndHistory(AssetCommentAndHistorySearchCriteriaInputModel assetCommentAndHistorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<byte[]> PrintAssets(AssetFileInputModel assetFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AllUsersAssetsModel> GetAllUsersAssets(AssetSearchCriteriaInputModel assetSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AssetsMultipleUpdateReturnModel> UpdateAssigneeForMultipleAssets(AssetsInputModel assetDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}