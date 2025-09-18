using Moq;
using Btrak.Services.Trading;
using Btrak.Models.TradeManagement;
using NUnit.Framework;
using System.Collections.Generic;
using System;
using Newtonsoft.Json;
using BTrak.Common;
using AutoFixture;
using Btrak.Models;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.BillingManagement;
using Btrak.Services.FormDataServices;
using Btrak.Services.DocumentStorageServices;
using Btrak.Services.CompanyStructureManagement;
using Btrak.Services.CompanyStructure;
using Btrak.Services.HrManagement;
using Btrak.Services.Email;
using Btrak.Services.Chromium;
using Btrak.Dapper.Dal.Partial;
using Btrak.Services.FileUpload;
using Btrak.Models.FormDataServices;
using System.Threading.Tasks;
using System.Linq;
using Btrak.Models.BillingManagement;
using Btrak.Models.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Models.MasterData;
using Btrak.Models.CompanyStructureManagement;
using Btrak.Services.TimeZone;
using Btrak.Services.Lives;

namespace Btrak.Api.Tests.Trading
{
    [TestFixture]
    public class TradingServiceUnitTests
    {
        private LoggedInContext _loggedInContext;
        private List<ValidationMessage> _validationMessages;
        private readonly Fixture fixture = new Fixture();
        private readonly TradingRepository _tradingRepository;
        private Mock<ClientRepository> _clientRepository;
        private readonly IDataSourceService _dataSourceService;
        private readonly IDocumentStorageService _documentStorageService;
        private Mock<IClientService> _clientService;
        private Mock<ICompanyStructureManagementService> _companyStructureManagementService;
        private Mock<ICompanyStructureService> _companyStructureService;
        private readonly IHrManagementService _hrManagementService;
        private Mock<IEmailService> _emailService;
        private readonly GoalRepository _goalRepository;
        private Mock<UserRepository> _userRepository;
        private Mock<IDataSetService> _dataSetService;
        private Mock<ILeadService> _leadService;
        private readonly ChromiumService _chromiumService;
        private Mock<MasterDataManagementRepository> _masterDataManagementRepository;
        private readonly IFileService _fileService;
        private readonly FileRepository _fileRepository;
        private readonly ITimeZoneService _timeZoneService;
        private Mock<CompanyStructureRepository> _companyStructureRepository;
        private readonly ILivesService _livesService;
        [SetUp]
        public void ReInitializeTest()
        {
            _loggedInContext = new LoggedInContext
            {
                LoggedInUserId = new Guid("372787d1-cfb7-4b2b-8aff-ae9e09c46388"),
                CompanyGuid = new Guid("aeb998ea-e271-4078-987a-dd40378f3ca4")
            };
            _validationMessages = new List<ValidationMessage>();
            _dataSetService = new Mock<IDataSetService>();
            _clientService = new Mock<IClientService>();
            _clientRepository = new Mock<ClientRepository>();
            _companyStructureService = new Mock<ICompanyStructureService>();
            _userRepository = new Mock<UserRepository>();
            _emailService = new Mock<IEmailService>();
            _companyStructureRepository = new Mock<CompanyStructureRepository>();
            _masterDataManagementRepository = new Mock<MasterDataManagementRepository>();
            _leadService = new Mock<ILeadService>();
            _companyStructureManagementService = new Mock<ICompanyStructureManagementService>();
        }
        [TestCase("5f309987-18c8-4a44-8384-ff9b981865ac", "3785be82-a47f-454e-961a-a866374ee0d4", "4f7de32d-a3e1-4aa1-b8f3-cc1b4d6854d9", "Purchase")]
        [TestCase("5f309987-18c8-4a44-8384-ff9b981865ac", null, null, null, null, null)]
        public void PurchaseContractDraftBlDetails(Guid? contractId, Guid? purchaseId, Guid? dataSourceId, string contractType)
        {
            //Arrange
            PurchaseExecutionModel purchaseExecutionModel = new PurchaseExecutionModel()
            {
                ContractId = contractId,
                PurchaseIds = new List<Guid?>()
                {
                    purchaseId,
                    purchaseId
                },
                DataSourceId = dataSourceId,
                ContractType = contractType
            };
            List<DraftBlDetails> blDraft = new List<DraftBlDetails>()
            {
                new DraftBlDetails()
                {
                        BlDate = Convert.ToDateTime("2022-06-10T00:00:00Z"),
                        BlNumber = "1",
                        TotalQuantity = 1,
                        Consignee = "1",
                        Consigner = "1",
                        NotifyParty = "1",
                        ContractUrl = "https://bviewstorage.blob.core.windows.net/ad73d631-9f10-46fb-a14f-8bbb2c79b66e/projects/fb3fed1e-3a93-4c6c-8fa9-8c33ab0be6bb/Draft%20BL-1.pdf",
                        Id = new Guid("7cd8b63e-c8ac-4cdb-9fd5-e7a21f69264a")
                },
                new DraftBlDetails()
                {
                        BlDate = Convert.ToDateTime("2022-06-18T00:00:00Z"),
                        BlNumber = "2",
                        TotalQuantity = 2,
                        Consignee = "2",
                        Consigner = "2",
                        NotifyParty = "2",
                        ContractUrl = "https://bviewstorage.blob.core.windows.net/ad73d631-9f10-46fb-a14f-8bbb2c79b66e/projects/fb3fed1e-3a93-4c6c-8fa9-8c33ab0be6bb/Draft%20BL-1.pdf",
                        Id = new Guid("fc31f73a-e683-4a93-a3ad-e2a8e995097c")
                }
            };
            List<PurchaseExecutionModel> purchaseExecutionModels = new List<PurchaseExecutionModel>();
            PurchaseContractDraftBlDetails purchaseContractDraftBlDetails = new PurchaseContractDraftBlDetails();
            Mock<TradingService> tradingServiceMock = this.GetInstance();
            if (purchaseId != null && dataSourceId != null && contractType != null)
            {
                purchaseExecutionModels = new List<PurchaseExecutionModel>()
                {
                    new PurchaseExecutionModel()
                    {
                        ContractType = "ExecutionSteps",
                        ContractUrl = "",
                        ContractId = new Guid("5f309987-18c8-4a44-8384-ff9b981865ac"),
                        PurchaseId = new Guid("3785be82-a47f-454e-961a-a866374ee0d4"),
                        DataSourceId = new Guid("4f7de32d-a3e1-4aa1-b8f3-cc1b4d6854d9"),
                        StatusName = "Initialized",
                        StepName = "Q88"
                    },
                    new PurchaseExecutionModel()
                    {
                        ContractType = "ExecutionSteps",
                        ContractUrl = "",
                        ContractId = new Guid("5f309987-18c8-4a44-8384-ff9b981865ac"),
                        PurchaseId = new Guid("3785be82-a47f-454e-961a-a866374ee0d4"),
                        DataSourceId = new Guid("4f7de32d-a3e1-4aa1-b8f3-cc1b4d6854d9"),
                        StatusName = "Accepted",
                        StepName = "Lifting of Subjects"
                    },
                    new PurchaseExecutionModel()
                    {
                        BlDraftForm = blDraft,
                        ContractType = "ExecutionSteps",
                        ContractId = new Guid("5f309987-18c8-4a44-8384-ff9b981865ac"),
                        PurchaseId = new Guid("3785be82-a47f-454e-961a-a866374ee0d4"),
                        DataSourceId = new Guid("4f7de32d-a3e1-4aa1-b8f3-cc1b4d6854d9"),
                        StatusName = "Accepted",
                        StepName = "Purchase bl"
                    }
                };
                tradingServiceMock.Setup(x => x.GetXPSteps(purchaseExecutionModel, _loggedInContext, _validationMessages)).Returns(purchaseExecutionModels);
                purchaseContractDraftBlDetails = new PurchaseContractDraftBlDetails()
                {
                    ContractId = new Guid("5f309987-18c8-4a44-8384-ff9b981865ac"),
                    PurchaseId = new Guid("3785be82-a47f-454e-961a-a866374ee0d4"),
                    DataSourceId = new Guid("4f7de32d-a3e1-4aa1-b8f3-cc1b4d6854d9"),
                    StatusName = "Accepted",
                    BlDetails = blDraft
                };
            }
            else
            {
                tradingServiceMock.Setup(x => x.GetXPSteps(purchaseExecutionModel, _loggedInContext, _validationMessages)).Returns(purchaseExecutionModels);
            }
            _leadService.Setup(x => x.GetPortDetails(It.IsAny<PaymentTermSearchInputModel>(), _loggedInContext, _validationMessages)).Returns(new List<PaymentTermOutputModel>());
            _companyStructureManagementService.Setup(x => x.GetCountries(It.IsAny<CountrySearchInputModel>(), _validationMessages, _loggedInContext)).Returns(new List<CountryApiReturnModel>());
            //Act
            var draftBlForPurchaseContracts = tradingServiceMock.Object.GetPurchaseContractDraftBlDetails(purchaseExecutionModel, _loggedInContext, _validationMessages);
            //Assert
            foreach (var draftBlForPurchaseContract in draftBlForPurchaseContracts)
            {
                if (purchaseExecutionModel.PurchaseIds != null && purchaseExecutionModel.DataSourceId != null && purchaseExecutionModel.ContractType != null)
                {
                    Assert.AreEqual(purchaseContractDraftBlDetails.BlDetails[0].Id, draftBlForPurchaseContract.BlDetails[0].Id);
                    Assert.AreEqual(purchaseContractDraftBlDetails.BlDetails[0].ContractUrl, draftBlForPurchaseContract.BlDetails[0].ContractUrl);
                    Assert.AreEqual(purchaseContractDraftBlDetails.BlDetails[1].Id, draftBlForPurchaseContract.BlDetails[1].Id);
                    Assert.AreEqual(purchaseContractDraftBlDetails.BlDetails[1].ContractUrl, draftBlForPurchaseContract.BlDetails[1].ContractUrl);
                    Assert.AreEqual(purchaseContractDraftBlDetails.StatusName, draftBlForPurchaseContract.StatusName);
                    Assert.AreEqual(purchaseContractDraftBlDetails.PurchaseId, draftBlForPurchaseContract.PurchaseId);
                }
                else
                {
                    Assert.AreEqual(null, draftBlForPurchaseContract.BlDetails);
                    Assert.AreEqual(null, draftBlForPurchaseContract.StatusName);
                    Assert.AreEqual(null, draftBlForPurchaseContract.PurchaseId);
                }
            }
        }
        [TestCase("5f309987-18c8-4a44-8384-ff9b981865ac", "3785be82-a47f-454e-961a-a866374ee0d4", "4f7de32d-a3e1-4aa1-b8f3-cc1b4d6854d9", "Purchase")]
        public void PurchaseContractDraftBlDetails_ExceptionHandling(Guid? contractId, Guid? purchaseId, Guid? dataSourceId, string contractType)
        {
            //Arrange
            PurchaseExecutionModel purchaseExecutionModel = new PurchaseExecutionModel()
            {
                ContractId = contractId,
                PurchaseIds = new List<Guid?>()
                {
                    purchaseId,
                    purchaseId
                },
                DataSourceId = dataSourceId,
                ContractType = contractType
            };
            Mock<TradingService> tradingServiceMock = this.GetInstance();
            tradingServiceMock.Setup(x => x.GetXPSteps(purchaseExecutionModel, _loggedInContext, _validationMessages)).Throws<Exception>();

            //Act
            var draftBlForPurchaseContract = tradingServiceMock.Object.GetPurchaseContractDraftBlDetails(purchaseExecutionModel, _loggedInContext, _validationMessages);
            //Assert
            Assert.IsTrue(_validationMessages.Count > 0);
        }
        [TestCase("4f03bc2c-f053-4aad-b7d0-62cf7f94d5a5","37db4542-63b1-489c-9629-d36feda3e810", "1fd48c2b-0ec5-4263-8d34-38cc0a0f7dfc", 
            "243cd16d-4654-4294-a06e-0822c4a41ccd", "9e5596f7-b8bc-4b56-91d2-637f95de9545", "37db4542-63b1-489c-9629-d36feda3e810")]
        [TestCase(null, null,null,null,null, "37db4542-63b1-489c-9629-d36feda3e810")]
        public void UpsertSwitchBlContractDetails(Guid? contractTemplateId,Guid? dataSetId,Guid? vesselId,Guid? createdByUserId,
            Guid? selectedClientId,Guid? expectedResult)
        {
            //Arrange
            List<SwitchBlContractModel> switchBlContractModelList = new List<SwitchBlContractModel>();
            List<FinalSwitchBlModel> finalSwitchBlModelList = new List<FinalSwitchBlModel>();
            List<FinalSwitchBlModel> FinalSwithBlModel = new List<FinalSwitchBlModel>();
            SwitchBlContractModel switchBlContractModel = new SwitchBlContractModel()
            {
                DataSetId = dataSetId,
                VesselId = vesselId,
                CreatedByUserId = createdByUserId,
                IsShareSwitchBlContract = false,
                SelectedClientId = selectedClientId,
                StatusName = "BlsCreated"
            };

            FinalSwitchBlModel finalSwitchBlModel = new FinalSwitchBlModel()
            {
                DataSetId = dataSetId,
                VesselId = vesselId,
                IsShareSwitchBlContract = false
            };
            finalSwitchBlModelList.Add(finalSwitchBlModel);

            switchBlContractModelList.Add(switchBlContractModel);
            List<ContractModel> contractModels = new List<ContractModel>();
            ContractModel contractModel = new ContractModel
            {
                DataSetId = switchBlContractModel.VesselId
            };
            contractModels.Add(contractModel);
            Mock<TradingService> tradingServiceMockForSwitchBl = this.GetInstance();
            tradingServiceMockForSwitchBl.Setup(x => x.GenerateDraftBls(It.IsAny<SwitchBlContractModel>(), It.IsAny<int?>(), It.IsAny<string>())).Returns(switchBlContractModel);
            tradingServiceMockForSwitchBl.Setup(x => x.GetSwitchBlContracts(It.IsAny<SwitchBlContractModel>(), _loggedInContext, _validationMessages)).Returns(finalSwitchBlModelList);
            tradingServiceMockForSwitchBl.Setup(x => x.GetContracts(It.IsAny<ContractModel>(), _loggedInContext, _validationMessages)).Returns(contractModels);
            if (contractTemplateId != null && dataSetId != null)
            {
                _dataSetService.Setup(x => x.CreateDataSet(It.IsAny<DataSetUpsertInputModel>(), _loggedInContext, _validationMessages)).ReturnsAsync((Guid)switchBlContractModel.DataSetId);
            }
            else
            {
                _dataSetService.Setup(x => x.CreateDataSet(It.IsAny<DataSetUpsertInputModel>(), _loggedInContext, _validationMessages)).ReturnsAsync(new Guid());
            }
            //Act
            var actualResult = tradingServiceMockForSwitchBl.Object.UpsertSwitchBlContract(switchBlContractModel, _loggedInContext, _validationMessages).GetAwaiter().GetResult();
            //Assert
            if (contractTemplateId != null && dataSetId != null)
            {
                Assert.AreEqual(expectedResult, actualResult);
            }
            else
            {
                Assert.AreNotEqual(expectedResult, actualResult);
            }
        }
        [TestCase(null,null,null,null,null,null)]
        public void UpsertSwitchBlContractDetails_ExceptionHandling(Guid? contractTemplateId, Guid? dataSetId, Guid? vesselId, Guid? createdByUserId,
            Guid? selectedClientId, Guid? expectedResult)
        {
            //Arrange
            SwitchBlContractModel switchBlContractModel = new SwitchBlContractModel()
            {
                DataSetId = dataSetId,
                VesselId = vesselId,
                CreatedByUserId = createdByUserId,
                IsShareSwitchBlContract = false,
                SelectedClientId = selectedClientId
            };
            Mock<TradingService> tradingServiceMockForSwitchBl = this.GetInstance();
            tradingServiceMockForSwitchBl.Setup(x => x.GetSwitchBlContracts(It.IsAny<SwitchBlContractModel>(), _loggedInContext, _validationMessages)).Throws<Exception>();
            //Act
            var actualResult = tradingServiceMockForSwitchBl.Object.UpsertSwitchBlContract(switchBlContractModel, _loggedInContext, _validationMessages).GetAwaiter().GetResult();
            //Assert
            Assert.IsTrue(_validationMessages.Count > 0);
        }
        [TestCase("37db4542-63b1-489c-9629-d36feda3e810", "9e5596f7-b8bc-4b56-91d2-637f95de9545",false)]
        [TestCase(null, null,false)]
        public void GetSwitchBlBuyerContractDetails(Guid? dataSetId,Guid? clientId,bool? isArchievd)
        {
            //Arrange
            SwitchBlBuyerContractInputModel switchBlBuyerContractInputModel = new SwitchBlBuyerContractInputModel()
            {
                DataSetId = dataSetId,
                ClientId = clientId,
                IsArchived = isArchievd
            };
            List<SplitBlModel> splitBlModels = new List<SplitBlModel>()
            {
                 new SplitBlModel()
                 {
                      Consignee = "s",
                      Consigner = "g",
                      DraftBlNumber = "BLB1",
                      NotifyParty =  "sg",
                      Quantity = 1000
                 }
            };
            PurchaseContractDetails purchaseContractDetails = new PurchaseContractDetails()
            {
                Consignee = "c",
                Consigner = "h",
                DraftBlNumber = "BLB2",
                NotifyParty = "ch",
                Quantity = 500,
                PurchaseContractId = (Guid?)new Guid("3785be82-a47f-454e-961a-a866374ee0d4"),
                SaleContractId = (Guid?)new Guid("5d20405c-33c8-4343-8a61-8372ef705924")
            };
            List<SwitchBlDetailsModel> switchBlDetailsModels = new List<SwitchBlDetailsModel>()
            {
                new SwitchBlDetailsModel()
                {
                    ClientId = clientId,
                    ActionType = "combine",
                    IsQuantitySplited = true,
                    SplitList = splitBlModels,
                    PurchaseContractDetails = new PurchaseContractDetails()
                    {
                        PurchaseContractId = (Guid?)new Guid("3785be82-a47f-454e-961a-a866374ee0d4"),
                        SaleContractId = (Guid?)new Guid("5d20405c-33c8-4343-8a61-8372ef705924")
                    }
                },
                new SwitchBlDetailsModel()
                {
                    ClientId = clientId,
                    ActionType = "onetoone",
                    PurchaseContractDetails = purchaseContractDetails
                }
            };
            List<DataSetOutputModel> dataSetOutputModels = new List<DataSetOutputModel>();
            Mock<TradingService> tradingServiceMock = this.GetInstance();
            if(dataSetId != null && clientId != null)
            {
                DataSetOutputModel dataSetOutputModel = new DataSetOutputModel()
                {
                    CreatedByUserId = (Guid?)new Guid("243cd16d-4654-4294-a06e-0822c4a41ccd"),
                    DataSourceId = (Guid?)new Guid("4f03bc2c-f053-4aad-b7d0-62cf7f94d5a5"),
                    Id = dataSetId,
                    DataJson = new DataSetConversionModel()
                    {
                        SwitchBlDetails = switchBlDetailsModels
                    }
                };
                dataSetOutputModels.Add(dataSetOutputModel);
                //_dataSetService.Setup(x => x.SearchDataSets(It.IsAny<Guid?>(), It.IsAny<Guid?>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<bool?>()
                //, It.IsAny<bool?>(), It.IsAny<int?>(), It.IsAny<int?>(), _loggedInContext, _validationMessages, null, null, null, null, null, null)).ReturnsAsync(dataSetOutputModels);
            }
            else
            {
                //_dataSetService.Setup(x => x.SearchDataSets(It.IsAny<Guid?>(), It.IsAny<Guid?>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<bool?>()
                //, It.IsAny<bool?>(), It.IsAny<int?>(), It.IsAny<int?>(), _loggedInContext, _validationMessages, null, null, null, null, null, null)).ReturnsAsync(dataSetOutputModels);
            }
            //Act
            var switchBlBuyerContractDetails = tradingServiceMock.Object.GetSwitchBlBuyerContracts(switchBlBuyerContractInputModel, _loggedInContext, _validationMessages);
            //Assert
            if (dataSetId != null && clientId != null)
            {
                Assert.AreEqual(splitBlModels[0].DraftBlNumber, switchBlBuyerContractDetails.BuyerSwitchBlContractDetails[0].BlNumber);
                Assert.AreEqual(splitBlModels[0].Quantity, switchBlBuyerContractDetails.BuyerSwitchBlContractDetails[0].Quantity);
                Assert.AreEqual(splitBlModels[0].NotifyParty, switchBlBuyerContractDetails.BuyerSwitchBlContractDetails[0].NotifyParty);
                Assert.AreEqual(purchaseContractDetails.DraftBlNumber, switchBlBuyerContractDetails.BuyerSwitchBlContractDetails[1].BlNumber);
                Assert.AreEqual(purchaseContractDetails.Quantity, switchBlBuyerContractDetails.BuyerSwitchBlContractDetails[1].Quantity);
                Assert.AreEqual(purchaseContractDetails.NotifyParty, switchBlBuyerContractDetails.BuyerSwitchBlContractDetails[1].NotifyParty);
            }
            else
            {
                Assert.IsTrue(switchBlBuyerContractDetails.BuyerSwitchBlContractDetails == null);
            }
        }
        [TestCase("37db4542-63b1-489c-9629-d36feda3e810", "9e5596f7-b8bc-4b56-91d2-637f95de9545", false)]
        public void GetSwitchBlBuyerContractDetails_ExceptionHandling(Guid? dataSetId, Guid? clientId, bool? isArchievd)
        {
            //Arrange
            SwitchBlBuyerContractInputModel switchBlBuyerContractInputModel = new SwitchBlBuyerContractInputModel()
            {
                DataSetId = dataSetId,
                ClientId = clientId,
                IsArchived = isArchievd
            };
            Mock<TradingService> tradingServiceMock = this.GetInstance();
            //_dataSetService.Setup(x => x.SearchDataSets(It.IsAny<Guid?>(), It.IsAny<Guid?>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<bool?>()
            //                  , It.IsAny<bool?>(), It.IsAny<int?>(), It.IsAny<int?>(), _loggedInContext, _validationMessages, null, null, null, null, null, null)).Throws<Exception>();
            //Act
            var switchBlBuyerContractDetails = tradingServiceMock.Object.GetSwitchBlBuyerContracts(switchBlBuyerContractInputModel, _loggedInContext, _validationMessages);
            //Assert
            Assert.IsTrue(_validationMessages.Count > 0 );
        }
        [TestCase("37db4542-63b1-489c-9629-d36feda3e810")]
        [TestCase(null)]
        public void UpsertContract_CheckingTradeId(Guid? tradeId)
        {
            //Arrange
            List<Guid> purchaseContractIds = new List<Guid>()
            {
                 new Guid("373c2d16-fb1f-465a-868f-adb2051449b4")
            };
            List<Guid> saleContractIds = new List<Guid>()
            {
                 new Guid("32bcfe2e-f820-45f8-bec8-896c5a5ca343")
            };
            List<ContractModel> contractModels = new List<ContractModel>();
            ContractModel contractModel = new ContractModel()
            {
                DataSetId = tradeId,
                PurchaseContractIds = purchaseContractIds,
                SalesContractIds = saleContractIds,
                ContractType = "vessel"
            };
            contractModels.Add(contractModel);
            SaleContractFormModel saleContractFormModel = new SaleContractFormModel()
            {
                ContractNumber = "22ndpurchase001T",
                CommodityName = "1bf92d32-3412-4d01-9fe4-77092e92ecfe",
                QuantityMeasurementUnit = "metricTonnes",
                SellerName = "Siri"
            };
            List<VesselDetailsModel> vesselDetailsModels = new List<VesselDetailsModel>()
            {
                new VesselDetailsModel()
                    {
                        VesselId = tradeId != null?(Guid)tradeId:new Guid(),
                        PurchaseContractIds = purchaseContractIds,
                        SalesContractIds = saleContractIds
                    }
            };
            ContractModel contractVesselDetails = new ContractModel()
            {
                DataSetId = tradeId,
                ContractType = "vessel",
                IsContractLink = true,
                TradeId = tradeId,
                FormData = JsonConvert.SerializeObject(saleContractFormModel)
            };
            contractVesselDetails.VesselDetailsModel = tradeId != null ? vesselDetailsModels : null;
            List <ProductListOutPutModel> productsList = new List<ProductListOutPutModel>()
            {
                new ProductListOutPutModel()
                {
                    ProductId = new Guid("1bf92d32-3412-4d01-9fe4-77092e92ecfe"),
                    ProductName = "sale Contract"
                }
            };
            ClientOutputModel clientOutputModel = new ClientOutputModel()
            {
                FullName = "koti"
            };
            Mock<TradingService> tradingServiceMockForTradeId = this.GetInstance();
            tradingServiceMockForTradeId.Setup(x => x.GetContracts(It.IsAny<ContractModel>(), _loggedInContext, _validationMessages)).Returns(contractModels);
            tradingServiceMockForTradeId.Setup(x => x.SaveHistory(It.IsAny<ContractModel>(), It.IsAny<ContractModel>(), _validationMessages, _loggedInContext,It.IsAny<string>()));
            if (tradeId != null)
            {
                _dataSetService.Setup(x => x.CreateDataSet(It.IsAny<DataSetUpsertInputModel>(), _loggedInContext, _validationMessages)).ReturnsAsync((Guid)tradeId);
            }
            else
            {
                _dataSetService.Setup(x => x.CreateDataSet(It.IsAny<DataSetUpsertInputModel>(), _loggedInContext, _validationMessages)).ReturnsAsync(new Guid());
            }
            _dataSetService.Setup(x => x.UpdateDataSetJson(It.IsAny<UpdateDataSetJsonModel>(), _loggedInContext, _validationMessages)).ReturnsAsync(tradeId != null ? (Guid)tradeId : new Guid());
            _clientService.Setup(x => x.GetProductsList(It.IsAny<MasterProduct>(), _loggedInContext, _validationMessages)).Returns(productsList);
            _clientRepository.Setup(x => x.GetClientByUserId(It.IsAny<string>(), It.IsAny<Guid?>(), _loggedInContext, _validationMessages, It.IsAny<Guid?>())).Returns(clientOutputModel);
            //Act
            var actualResult = tradingServiceMockForTradeId.Object.UpsertContract(contractVesselDetails, _loggedInContext, _validationMessages).GetAwaiter().GetResult();
            //Assert
            if (tradeId != null)
            {
                Assert.AreEqual(tradeId, actualResult);
            }
            else
            {
                Assert.AreNotEqual(tradeId, actualResult);
            }
        }
        [Test]
        public void UpsertContract_ExceptionHandling()
        {
            //Arrange
            List<Guid> purchaseContractIds = new List<Guid>()
            {
                 new Guid("373c2d16-fb1f-465a-868f-adb2051449b4")
            };
            List<Guid> saleContractIds = new List<Guid>()
            {
                 new Guid("32bcfe2e-f820-45f8-bec8-896c5a5ca343")
            };
            SaleContractFormModel saleContractFormModel = new SaleContractFormModel()
            {
                ContractNumber = "22ndpurchase001T",
                CommodityName = "1bf92d32-3412-4d01-9fe4-77092e92ecfe",
                QuantityMeasurementUnit = "metricTonnes",
                SellerName = "Siri"
            };
            ContractModel contractVesselDetails = new ContractModel()
            {
                DataSetId = new Guid("373c2d16-fb1f-465a-868f-adb2051449b4"),
                ContractType = "vessel",
                VesselDetailsModel = new List<VesselDetailsModel>()
                {
                    new VesselDetailsModel()
                    {
                        PurchaseContractIds = purchaseContractIds,
                        SalesContractIds = saleContractIds
                    }
                },
                FormData = JsonConvert.SerializeObject(saleContractFormModel),
                IsContractLink = true
            };
            Mock<TradingService> tradingServiceMockForTradeId = this.GetInstance();
            tradingServiceMockForTradeId.Setup(x => x.GetContracts(It.IsAny<ContractModel>(), _loggedInContext, _validationMessages)).Throws<Exception>();
            //Act
            var actualResult = tradingServiceMockForTradeId.Object.UpsertContract(contractVesselDetails, _loggedInContext, _validationMessages).GetAwaiter().GetResult();
            //Assert
            Assert.IsTrue(_validationMessages.Count > 0);
        }
        [Test]
        public void UpsertContract_InvoiceQueue()
        {
            //Arrange
            List<ContractModel> contractModels = new List<ContractModel>();
            SaleContractFormModel saleContractFormModel = new SaleContractFormModel()
            {
                ContractNumber = "22ndpurchase001T",
                CommodityName = "1bf92d32-3412-4d01-9fe4-77092e92ecfe",
                QuantityMeasurementUnit = "metricTonnes",
                SellerName = "Siri"
            };
            ContractModel contractModel = new ContractModel()
            {
                DataSetId = new Guid("0e67db9a-a089-45b8-a2dc-b876504c1df8"),
                ClientId = new Guid("009b5d1c-bd8b-4921-89b4-fa9456d4d410"),
                BrokerId = new Guid("77661de0-3a06-4495-a96e-27d38eedc42e"),
                ContractType = "Invoice Queue",
                IsShareCreditOrDebitNote = true,
                FormData = JsonConvert.SerializeObject(saleContractFormModel),
                ContractData = new ContractModel()
                {
                    FormData = JsonConvert.SerializeObject(saleContractFormModel)
                }
            };
            contractModels.Add(contractModel);
            List<ClientOutputModel> clientList = new List<ClientOutputModel>()
            {
                new ClientOutputModel()
                {
                    Email = "koti@snovasys.com",
                    CountryCode = "+91",
                    MobileNo = "6300822191"
                }
            };
            List<ProductListOutPutModel> productsList = new List<ProductListOutPutModel>()
            {
                new ProductListOutPutModel()
                {
                    ProductId = new Guid("1bf92d32-3412-4d01-9fe4-77092e92ecfe"),
                    ProductName = "sale Contract"
                }
            };
            List<EmailTemplateModel> emailTemplateModels = new List<EmailTemplateModel>()
            {
                new EmailTemplateModel()
                {
                    EmailSubject = "##CreditOrDebitNote## Acceptence by contracter - ##InvoiceNo## for ##ContractId##",
                    EmailTemplate = "< !doctype html >\r\n < html lang =\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1,shrink-to-fit=no\">\r\n<meta name=\"x-apple-disable-message-reformatting\">\r\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><title>Invoice pdf</title>\r\n<style type=\"text/css\">\r\na{text-decoration:none;outline:0}@media (max-width:649px){.o_col-full{max-width:100%!important}.o_col-half{max-width:50%!important}.o_hide-lg{display:inline-block!important;font-size:inherit!important;max-height:none\r\n!important;line-height:inherit!important;overflow:visible!important;width:auto!important;visibility:visible!important}.o_hide-xs,.o_hide-xs.o_col_i{display:none!important;font-size:0!important;max-height:0\r\n!important;width:0!important;line-height:0!important;overflow:hidden!important;visibility:hidden!important;height:0!important}.o_xs-center{text-align:center!important}.\r\no_xs-left{text-align:left!important}.o_xs-right{text-align:left!important}table.o_xs-left{margin-left:0!important;margin-right:auto!important;float:none!important}table.o_xs-right\r\n{margin-left:auto!important;margin-right:0!important;float:none!important}table.o_xs-center{margin-left:auto!important;margin-right:auto!important;float:none!important}h1.\r\no_heading{font-size:32px!important;line-height:41px!important}h2.o_heading{font-size:26px!important;line-height:37px!important}h3.o_heading{font-size:20px!important;line-height:30px!important}.\r\no_xs-py-md{padding-top:24px!important;padding-bottom:24px!important}.o_xs-pt-xs{padding-top:8px!important}.o_xs-pb-xs{padding-bottom:8px!important}}@media screen{@font-face{font-family:Roboto;font-style:normal;\r\nfont-weight:400;src:local(\"Roboto\"),local(\"Roboto-Regular\"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format(\"woff2\");\r\nunicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;\r\nfont-weight:400;src:local(\"Roboto\"),local(\"Roboto-Regular\"),url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) \r\nformat(\"woff2\");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Roboto;\r\nfont-style:normal;font-weight:700;src:local(\"Roboto Bold\"),local(\"Roboto-Bold\"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) \r\nformat(\"woff2\");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Roboto;font-style:normal;font-weight:700;src:local(\"Roboto Bold\"),\r\nlocal(\"Roboto-Bold\"),url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format(\"woff2\");\r\nunicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}.\r\no_heading,.o_sans{font-family:Roboto,sans-serif!important}.o_heading,b,strong{font-weight:700!important}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}}</style>\r\n</head>\r\n<body class=\"o_body o_bg-light\" style=\"width:100%;margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#dbe5ea\">\r\n<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_hide\" align=\"center\" style=\"display:none;font-size:0;max-height:0;width:0;line-height:0;overflow:hidden;mso-hide:all;visibility:hidden\">Email Summary (Hidden)</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-light o_px-xs o_pt-lg o_xs-pt-xs\" align=\"center\" style=\"background-color:#dbe5ea;padding-left:8px;padding-right:8px;padding-top:32px\">\r\n<!--[if mso]><table width=\"632\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tbody><tr><td><![endif]-->\r\n<table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" style=\"max-width:632px;margin:0 auto\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-primary o_px o_py-md o_br-t o_sans o_text\" align=\"center\" style=\"font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#126de5;border-radius:4px 4px 0 0;padding-left:16px;padding-right:16px;padding-top:24px;padding-bottom:24px\">\r\n<p style=\"margin-top:0;margin-bottom:0\">\r\n<a class=\"o_text-white\" style=\"text-decoration:none;outline:0;color:#fff\">\r\n<img src=\"##CompanyLogo##\" width=\"136\" height=\"36\" style=\"max-width:136px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none\">\r\n</a>\r\n</p>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<!--[if mso]><![endif]-->\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-light o_px-xs\" align=\"center\" style=\"background-color:#dbe5ea;padding-left:8px;padding-right:8px\">\r\n<!--[if mso]><table width=\"632\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tbody><tr><td><![endif]-->\r\n<table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" style=\"max-width:632px;margin:0 auto\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light\" align=\"center\" style=\"font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:19px;line-height:28px;background-color:#fff;color:#82899a;padding-left:24px;padding-right:24px;padding-top:64px;padding-bottom:5px\">\r\n<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max\" align=\"center\" style=\"font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;color:#424651;border:2px solid #126de5;border-radius:96px;padding-left:16px;padding-right:16px;padding-top:16px;padding-bottom:16px\">\r\n<img src=\"https://bviewstorage.blob.core.windows.net/mailtemplatefiles/user-assignee.png\" \r\nwidth=\"48\" height=\"48\" alt=\"\" style=\"max-width:48px;-ms-interpolation-mode:bicubic;vertical-align:middle;border:0;line-height:100%;height:auto;outline:0;text-decoration:none\">\r\n</td>\r\n</tr>\r\n<tr>\r\n<td style=\"font-size:24px;line-height:24px;height:24px\">&nbsp;\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<h2 class=\"o_heading o_text-dark o_mb-xxs\" style=\"font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:4px;color:#242b3d;font-size:30px;line-height:39px\">##CreditOrDebitNote## Acceptence\r\n - ##InvoiceNo## for ##ContractId##\r\n</h2>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<!--[if mso]>\r\n<![endif]-->\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-light o_px-xs\" align=\"center\" style=\"background-color:#dbe5ea;padding-left:8px;padding-right:8px\">\r\n<!--[if mso]><table width=\"632\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tbody><tr><td><![endif]-->\r\n<table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" style=\"max-width:632px;margin:0 auto\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"center\" \r\nstyle=\"font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px\">\r\n<div class=\"o_px-xs\" style=\"padding-left:8px;padding-right:8px\">\r\n<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_re o_bt-light\" style=\"font-size:16px;line-height:16px;height:16px;vertical-align:top;border-top:1px solid #d3dce0\">&nbsp;\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</div>\r\n<p style=\"margin-top:0;margin-bottom:0\">Hello,<br>Please find the ##CreditOrDebitNote## for your next action.<br>Thank you.\r\n</p>\r\n</p>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<!--[if mso]><![endif]-->\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-light o_px-xs\" align=\"center\" style=\"background-color:#dbe5ea;padding-left:8px;padding-right:8px\">\r\n<!--[if mso]><table width=\"632\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tbody><tr><td><![endif]-->\r\n<table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" style=\"max-width:632px;margin:0 auto\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"center\" \r\nstyle=\"font-family:Helvetica,Arial,sans-serif;margin-top:0;margin-bottom:0;font-size:16px;line-height:5px;background-color:#fff;color:#424651;padding-left:24px;padding-right:24px;padding-top:16px;padding-bottom:16px\">\r\n<p style=\"margin-top:0;margin-bottom:0\">Click on link for further details</p>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<!--[if mso]><![endif]-->\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-light o_px-xs\" align=\"center\" style=\"background-color:#dbe5ea;padding-left:8px;padding-right:8px\">\r\n<!--[if mso]><table width=\"632\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tbody><tr><td><![endif]-->\r\n<table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" style=\"max-width:632px;margin:0 auto\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-white o_px-md o_py-xs\" align=\"center\" style=\"background-color:#fff;padding-left:24px;padding-right:24px;padding-top:8px;padding-bottom:8px\">\r\n<table align=\"center\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td width=\"300\" class=\"o_btn o_bg-success o_br o_heading o_text\" align=\"center\" \r\nstyle=\"font-family:Helvetica,Arial,sans-serif;font-weight:700;margin-top:0;margin-bottom:0;font-size:16px;line-height:24px;mso-padding-alt:12px 24px;background-color:#0ec06e;border-radius:4px\">\r\n<a class=\"o_text-white\" href=\"##siteUrl##\" style=\"text-decoration:none;outline:0;color:#fff;display:block;padding:12px 24px;mso-text-raise:3px\">View ##CreditOrDebitNote##\r\n</a>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<!--[if mso]><![endif]-->\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-light o_px-xs\" align=\"center\" style=\"background-color:#dbe5ea;padding-left:8px;padding-right:8px\">\r\n<!--[if mso]><table width=\"632\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tbody><tr><td><![endif]-->\r\n<table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" style=\"max-width:632px;margin:0 auto\">\r\n<tbody>\r\n<tr>\r\n<td class=\"o_bg-white\" style=\"font-size:48px;line-height:16px;height:16px;background-color:#fff\">&nbsp;\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n<!--[if mso]><![endif]-->\r\n</td>\r\n</tr>\r\n</tbody>\r\n</table>\r\n</body>\r\n</html>",
                    EmailTemplateId = new Guid("9747e03e-1535-4e3f-88d4-8afd7d36af4b"),
                    EmailTemplateName = "ShareCreditOrDebitNoteToContracterEmailTemplate",
                    EmailTemplateReferenceId = new Guid("4f50c582-79c2-4837-9f6f-ad5d7260f0a1"),
                    ClientId = new Guid("009b5d1c-bd8b-4921-89b4-fa9456d4d410")
                }
            };
            SmtpDetailsModel smtpDetailsModel = new SmtpDetailsModel()
            {
                CompanyName = "Test company",
                FromAddress = "hello@nxusworld.com",
                FromName = "M1 Test Site",
                SmtpMail = "hello@nxusworld.com",
                SmtpPassword = "Nxusworld@1234",
                SmtpServer = "smtp.gmail.com",
                SmtpServerPort = "587"
            };
            CompanyOutputModel companyOutputModel = new CompanyOutputModel()
            {
                CompanyName = "Testcomapny",
                RegistrerSiteAddress = "https://sitecreation.nxusworld.com/#"
            };
            List<CompanySettingsSearchOutputModel> companySettingsSearchOutputModels = new List<CompanySettingsSearchOutputModel>()
            {
                new CompanySettingsSearchOutputModel()
                {
                    Key = "AdminMails",
                    Value = "saiteja.pinnamaneni@snovasys.co.uk"
                }
            };
            CompanyThemeModel companyThemeModel = new CompanyThemeModel();
            Mock<TradingService> tradingServiceMockForTradeId = this.GetInstance();
            _dataSetService.Setup(x => x.CreateDataSet(It.IsAny<DataSetUpsertInputModel>(), _loggedInContext, _validationMessages)).ReturnsAsync(new Guid("0e67db9a-a089-45b8-a2dc-b876504c1df8"));
            _clientService.Setup(x=>x.GetAllInvoicePaymentStatus(It.IsAny<ClientInvoiceStatus>(),_loggedInContext,_validationMessages)).Returns(new List<ClientInvoiceStatus>());
            _clientService.Setup(x=>x.GetClients(It.IsAny<ClientInputModel>(),_loggedInContext,_validationMessages)).Returns(clientList);
            tradingServiceMockForTradeId.Setup(x => x.GetContracts(It.IsAny<ContractModel>(), _loggedInContext, _validationMessages)).Returns(contractModels);
            _clientService.Setup(x => x.GetProductsList(It.IsAny<MasterProduct>(), _loggedInContext, _validationMessages)).Returns(productsList);
            _clientService.Setup(x => x.GetAllEmailTemplates(It.IsAny<EmailTemplateModel>(), _loggedInContext, _validationMessages)).Returns(emailTemplateModels);
            _userRepository.Setup(x => x.SearchSmtpCredentials(_loggedInContext, _validationMessages, It.IsAny<string>())).Returns(smtpDetailsModel);
            _companyStructureRepository.Setup(x => x.GetCompanyDetails(_loggedInContext, _validationMessages)).Returns(companyOutputModel);
            _companyStructureRepository.Setup(x => x.SearchCompanies(It.IsAny<CompanySearchCriteriaInputModel>(),_loggedInContext, _validationMessages)).Returns(It.IsAny<List<CompanyOutputModel>>());
            _companyStructureService.Setup(x => x.GetCompanyTheme(_loggedInContext.LoggedInUserId)).Returns(companyThemeModel);
            _masterDataManagementRepository.Setup(x => x.GetCompanySettings(It.IsAny<CompanySettingsSearchInputModel>(), _loggedInContext, _validationMessages)).Returns(companySettingsSearchOutputModels);
            //Act
            var actualResult = tradingServiceMockForTradeId.Object.UpsertContract(contractModel, _loggedInContext, _validationMessages).GetAwaiter().GetResult();
            //Assert
            Assert.IsTrue(_validationMessages.Count > 0);
        }
        private Mock<TradingService> GetInstance()
        {
            return new Mock<TradingService>(_tradingRepository, _clientRepository.Object, _dataSourceService, _documentStorageService, _hrManagementService, _clientService.Object, _companyStructureManagementService.Object
                , _emailService.Object, _goalRepository, _chromiumService, _userRepository.Object, _fileService, _dataSetService.Object, _companyStructureService.Object, _leadService.Object,
                _masterDataManagementRepository.Object,_fileRepository,_timeZoneService,_livesService);
        }
    }
}
