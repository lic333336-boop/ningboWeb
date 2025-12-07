package com.lchjy.controller;

import com.lchjy.entity.NingboFood;
import com.lchjy.service.FoodService;
import com.lchjy.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/food")
@Slf4j
public class FoodController {

    @Autowired
    private FoodService foodService;

    @GetMapping("/list")
    public Result list(@RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        log.info("查询美食列表: keyword={}, page={}, limit={}", keyword, page, limit);
        return Result.success(foodService.list(keyword, page, limit));
    }

    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        log.info("查询美食详情: id={}", id);
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
