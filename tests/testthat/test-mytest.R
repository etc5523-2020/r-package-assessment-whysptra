
  
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
  appDir <- system.file("app", package = "southeastcovid")
  testServer(appDir,{
    expect_equal(sum(southeast$cases), 1155749)
  })
})
