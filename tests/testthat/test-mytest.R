
  
test_that("valuebox", {
  
id <- "confirmed"
  
  expect_equal(
    valuebox(id),
    valuebox("confirmed")
  )
})

test_that("valuebox", {
  
  id <- "recovered"
  
  expect_equal(
    valuebox(id),
    valuebox("recovered")
  )
})


test_that("southeast",{
  library(shiny)
  appDir <- system.file("app", package = "southeastcovid")
  shiny::testServer(appDir,{
    expect_equal(sum(southeast$cases), 1155749)
  })
})
