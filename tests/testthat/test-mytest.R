
  
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

