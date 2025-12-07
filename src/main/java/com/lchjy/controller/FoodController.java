package com.lchjy.controller;

import com.lchjy.entity.NingboFood;
import com.lchjy.service.FoodService;
import com.lchjy.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/food")
@Slf4j
public class FoodController {

    @Autowired
    private FoodService foodService;

    @GetMapping("/list")
    public Result list(@RequestParam(required = false) String keyword) {
        log.info("查询美食列表: keyword={}", keyword);
        return Result.success(foodService.list(keyword));
    }

    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        return Result.success(foodService.getById(id));
    }

    @PostMapping("/add")
    public Result add(@RequestBody NingboFood food) {
        log.info("新增美食: {}", food);
        foodService.add(food);
        return Result.success();
    }

    @PostMapping("/update")
    public Result update(@RequestBody NingboFood food) {
        log.info("修改美食: {}", food);
        foodService.update(food);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        log.info("删除美食: id={}", id);
        foodService.delete(id);
        return Result.success();
    }
}
