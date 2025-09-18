
using BusinessView.Dapper.Dal.Repositories;
using Btrak.Models.PolicyReview;
using BTrak.Common;
using BusinessView.Dapper.Dal.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.PolicyReview
{
    public class PolicyReviewService: IPolicyReviewService
    {
        private readonly PolicyRepository _policyRepository = new PolicyRepository();
        private readonly PolicyCategoryRepository _policyCategoryRepository = new PolicyCategoryRepository();
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly PolicyReviewUserRepository _policyReviewUserRepository = new PolicyReviewUserRepository();
        private readonly PolicyReviewAuditRepository _policyReviewAuditRepository = new PolicyReviewAuditRepository();



        public void AddOrUpdateNewPolicy(CreateNewPolicyModel createNewPolicyModel,  LoggedInContext loggedInContext)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Or Update New Policy", "Policy Review Service"));

            PolicyDbEntity policyDbEntity;
            Guid policyId = new Guid();
                   
                if (createNewPolicyModel.Id == Guid.Empty)
                {
                    policyDbEntity = new PolicyDbEntity
                    {
                        Id = Guid.NewGuid(),
                        RefId = createNewPolicyModel.RefId,
                        Description = createNewPolicyModel.Description,
                        PdfFileBlobPath = createNewPolicyModel.PdfFileBlobPath,
                        WordFileBlobPath = createNewPolicyModel.WordFileBlobPath,
                        ReviewDate = createNewPolicyModel.ReviewDate,
                        CategoryId = createNewPolicyModel.CategoryId,
                        MustRead = createNewPolicyModel.MustRead,
                        CreatedDateTime = DateTime.Now,
                        CreatedByUserId = loggedInContext.LoggedInUserId
                    };
                    _policyRepository.Insert(policyDbEntity);
                    policyId = policyDbEntity.Id;
                }
                else
                {
                    policyDbEntity = _policyRepository.GetPolicy(createNewPolicyModel.Id);

                    if (policyDbEntity == null)
                    {
                        throw new Exception($"Policy with the given id {createNewPolicyModel.Id} is not found in the database.");
                    }

                    policyDbEntity.Description = createNewPolicyModel.Description;
                    policyDbEntity.PdfFileBlobPath = createNewPolicyModel.PdfFileBlobPath;
                    policyDbEntity.WordFileBlobPath = createNewPolicyModel.WordFileBlobPath;
                    policyDbEntity.ReviewDate = createNewPolicyModel.ReviewDate;
                    policyDbEntity.CategoryId = createNewPolicyModel.CategoryId;
                    policyDbEntity.MustRead = createNewPolicyModel.MustRead;
                    policyDbEntity.UpdatedDateTime = DateTime.Now;
                    policyDbEntity.UpdatedByUserId = loggedInContext.LoggedInUserId;

                    _policyRepository.Update(policyDbEntity);

                

                }           
            PolicyReviewUserDbEntity policyReviewUserDbEntity;
            

                if (createNewPolicyModel.Id == Guid.Empty)
                {
                    policyReviewUserDbEntity = new PolicyReviewUserDbEntity
                    {
                        Id = Guid.NewGuid(),
                        PolicyId = policyId,
                        HasRead = createNewPolicyModel.HasRead,  // To be Modify
                        StartTime = createNewPolicyModel.StartTime, // To be Modify
                        EndTime = createNewPolicyModel.EndTime,  // To be Modify
                        UserId = loggedInContext.LoggedInUserId,
                        CreatedDateTime = DateTime.Now,
                        CreatedByUserId = loggedInContext.LoggedInUserId
                    };

                    _policyReviewUserRepository.Insert(policyReviewUserDbEntity);
                   
                }
               
                else
                {
                    policyReviewUserDbEntity = _policyRepository.GetPolicyReviewUserDetails(createNewPolicyModel.Id);
                    if (policyReviewUserDbEntity == null)
                    {
                        throw new Exception($"Policy  with the given id {createNewPolicyModel.Id} is not found in the database.");
                    }

                    policyReviewUserDbEntity.HasRead = createNewPolicyModel.HasRead;
                    policyReviewUserDbEntity.StartTime = createNewPolicyModel.StartTime;
                    policyReviewUserDbEntity.EndTime = createNewPolicyModel.EndTime;
                    policyReviewUserDbEntity.UpdatedDateTime = DateTime.Now;
                    policyReviewUserDbEntity.UpdatedByUserId = loggedInContext.LoggedInUserId;

                    _policyReviewUserRepository.Update(policyReviewUserDbEntity);
                }

            PolicyReviewAuditDbEntity policyReviewAuditDbEntity;
            
                if(createNewPolicyModel.Id == Guid.Empty)
                {
                       policyReviewAuditDbEntity = new PolicyReviewAuditDbEntity
                       {
                           Id =  Guid.NewGuid(),
                           PolicyId = policyId,
                           OpenedDate = DateTime.Now,
                           ReadDate = DateTime.Now,  // To be Modify from here to last
                           InsertedDate = DateTime.Now,
                           DeletedDate = DateTime.Now,
                           UpdatedDate = DateTime.Now,
                           PrintedDate = DateTime.Now,
                           DownloadedDate = DateTime.Now,
                           ImportedDate = DateTime.Now,
                           ExportedDate = DateTime.Now,
                           CreatedDateTime = DateTime.Now,
                           CreatedByUserId = loggedInContext.LoggedInUserId
                       };
                 _policyReviewAuditRepository.Insert(policyReviewAuditDbEntity);
               
                }
                else
                {
                    policyReviewAuditDbEntity = _policyRepository.GetPolicyReviewAuditDetails(createNewPolicyModel.Id);
                    
                    if(policyReviewUserDbEntity == null)
                    {
                        throw new Exception($"Policy  with the given id {createNewPolicyModel.Id} is not found in the database.");
                    }

                    policyReviewAuditDbEntity.OpenedDate = createNewPolicyModel.OpenedDate;
                    policyReviewAuditDbEntity.ReadDate = createNewPolicyModel.ReadDate;
                    policyReviewAuditDbEntity.InsertedDate = createNewPolicyModel.InsertedDate;
                    policyReviewAuditDbEntity.DeletedDate = createNewPolicyModel.DeletedDate;
                    policyReviewAuditDbEntity.UpdatedDate = DateTime.Now;
                    policyReviewAuditDbEntity.PrintedDate = DateTime.Now;
                    policyReviewAuditDbEntity.DownloadedDate = DateTime.Now;
                    policyReviewAuditDbEntity.ImportedDate = DateTime.Now;
                    policyReviewAuditDbEntity.ExportedDate = DateTime.Now;

                    _policyReviewAuditRepository.Update(policyReviewAuditDbEntity);
                }




        }

        public IList<PolicyCategorySelectionModel> GetPolicyCategoryValues(Guid id)
        {
            IList<PolicyCategoryDbEntity> list = _policyCategoryRepository.SelectAll().Where(x => x.Id == id).ToList();
            IList<PolicyCategorySelectionModel> policyCategoryModel = new List<PolicyCategorySelectionModel>();

            foreach(PolicyCategoryDbEntity val in list)
            {
                PolicyCategorySelectionModel dropdownListVal = new PolicyCategorySelectionModel
                {
                    Id = val.Id,
                    CategoryName= val.CategoryName
                };
                policyCategoryModel.Add(dropdownListVal);
            }
            return policyCategoryModel;
        }

        public IList<PolicyUserSelectionModel> GetPolicyUserValues(Guid id)
        {
            IList<UserDbEntity> list = _userRepository.SelectAll().Where(x => x.Id == id).ToList();
            IList<PolicyUserSelectionModel> policyUserModel = new List<PolicyUserSelectionModel>();

            foreach(UserDbEntity val in list)
            {
                PolicyUserSelectionModel dropdownListVal = new PolicyUserSelectionModel
                {
                    Id = val.Id,
                    FirstName = val.FirstName
                };
                policyUserModel.Add(dropdownListVal);
            }
            return policyUserModel;
        }

        public CreateNewPolicyModel GetPolicyDetailsToTheTable()
        {
            CreateNewPolicyModel detailsOfPolicy = _policyRepository.GetPolicyDetailsToTheTable();
            return detailsOfPolicy;
        }
    }
}
