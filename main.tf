module "module-azure-fhir-api" {
  source = "./module-azure-fhir-api"
}

module "module-azure-fhir-server" {
  source = "./module-azure-fhir-server"
}

module "module-webapp-for-container" {
  source = "./module-webapp-for-container"
}

module "module-azure-fhir-container-registry" {
  source = "./module-azure-fhir-container-registry"
}
